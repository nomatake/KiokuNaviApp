import 'package:dio/dio.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/utils/constants.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager tokenManager;
  final List<String> publicEndpoints = [
    '/api/auth/student/login',
    '/api/auth/parent/login',
    '/api/auth/register',
    '/api/auth/forgot-password',
    '/api/auth/refresh',
  ];

  AuthInterceptor({required this.tokenManager});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // Add auth token if available
    final token = await tokenManager.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized errors for protected endpoints
    if (err.response?.statusCode == 401 &&
        !_isPublicEndpoint(err.requestOptions.path)) {
      try {
        // Attempt token refresh
        final refreshed = await tokenManager.refreshTokens();

        if (refreshed) {
          // Get the new token
          final newToken = await tokenManager.getAccessToken();

          if (newToken != null && newToken.isNotEmpty) {
            // Clone the failed request with new token
            final clonedRequest = err.requestOptions.copyWith();
            clonedRequest.headers['Authorization'] = 'Bearer $newToken';

            // Create a minimal Dio instance with proper configuration for retry
            final retryDio = Dio(BaseOptions(
              baseUrl: kBaseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 30),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ));

            // Retry the request
            try {
              final response = await retryDio.fetch(clonedRequest);
              return handler.resolve(response);
            } catch (retryError) {
              // If retry also fails, reject with original error
              return handler.reject(err);
            }
          }
        }

        // If refresh failed, clear tokens and reject
        await tokenManager.clearTokens();
        return handler.reject(err);
      } catch (refreshError) {
        // If refresh throws an error, clear tokens and reject original error
        await tokenManager.clearTokens();
        return handler.reject(err);
      }
    }

    // For all other errors, just pass them through
    handler.reject(err);
  }

  bool _isPublicEndpoint(String path) {
    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }
}
