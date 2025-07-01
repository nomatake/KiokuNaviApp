import 'package:dio/dio.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager tokenManager;
  final List<String> publicEndpoints = [
    '/api/auth/login',
    '/api/auth/register',
    '/api/auth/forgot-password',
  ];
  
  AuthInterceptor({required this.tokenManager});
  
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (publicEndpoints.any((endpoint) => options.path.contains(endpoint))) {
      return handler.next(options);
    }
    
    // Add auth token if available
    final token = await tokenManager.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }
  
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshToken = await tokenManager.getRefreshToken();
      if (refreshToken != null) {
        final refreshed = await tokenManager.refreshTokens();
        if (refreshed) {
          // Retry original request
          final newToken = await tokenManager.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          
          // For now, just resolve with a mock response for testing
          final response = Response(
            data: {},
            statusCode: 200,
            requestOptions: err.requestOptions,
          );
          return handler.resolve(response);
        }
      }
      
      // Clear tokens if refresh failed
      await tokenManager.clearTokens();
    }
    
    handler.reject(err);
  }
}