import 'package:dio/dio.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';

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
      // With Laravel Sanctum, 401 means token is expired/invalid
      // Clear the token and force user to re-login
      await tokenManager.clearToken();

      // Don't retry - user needs to login again
      return handler.reject(err);
    }

    // For all other errors, just pass them through
    handler.reject(err);
  }

  bool _isPublicEndpoint(String path) {
    return publicEndpoints.any((endpoint) => path == endpoint || path.startsWith('$endpoint/'));
  }
}
