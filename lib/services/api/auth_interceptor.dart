import 'package:dio/dio.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/utils/constants.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager tokenManager;
  final List<String> publicEndpoints = [
    'auth/login',
    'auth/register',
    'auth/forgot-password',
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
    final token = await tokenManager.getToken();
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
        // Attempt token refresh using direct API call (avoid circular dependency)
        final refreshed = await _refreshToken();

        if (refreshed) {
          // Get the new token
          final newToken = await tokenManager.getToken();

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

        // If refresh failed, clear token and reject
        await tokenManager.clearToken();
        return handler.reject(err);
      } catch (refreshError) {
        // If refresh throws an error, clear token and reject original error
        await tokenManager.clearToken();
        return handler.reject(err);
      }
    }

    // For all other errors, just pass them through
    handler.reject(err);
  }

  /// Attempts to refresh the access token using the current access token
  /// Returns true if successful, false otherwise
  /// Uses separate Dio instance to avoid circular dependency with AuthApi
  Future<bool> _refreshToken() async {
    try {
      final currentToken = await tokenManager.getToken();

      if (currentToken == null || currentToken.isEmpty) {
        return false;
      }

      // Create a minimal Dio instance for refresh call (no interceptors to avoid circular dependency)
      final dio = Dio(BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $currentToken',
        },
      ));

      // Call refresh endpoint (GET request as per Laravel routes)
      final response = await dio.get('auth/refresh');

      // Extract new access token from response and save it
      final data = response.data['data'] as Map<String, dynamic>?;
      final newAccessToken = data?['token'] as String?;

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        // Save the new access token
        await tokenManager.saveToken(newAccessToken);
        return true;
      }

      return false;
    } catch (e) {
      // Refresh failed
      return false;
    }
  }

  bool _isPublicEndpoint(String path) {
    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }
}
