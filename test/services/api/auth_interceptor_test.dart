import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kioku_navi/services/api/auth_interceptor.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';

@GenerateNiceMocks([MockSpec<TokenManager>(), MockSpec<RequestInterceptorHandler>(), MockSpec<ErrorInterceptorHandler>()])
import 'auth_interceptor_test.mocks.dart';

void main() {
  group('AuthInterceptor', () {
    late AuthInterceptor authInterceptor;
    late MockTokenManager mockTokenManager;
    
    setUp(() {
      mockTokenManager = MockTokenManager();
      authInterceptor = AuthInterceptor(tokenManager: mockTokenManager);
    });
    
    group('onRequest', () {
      test('should add Authorization header when token exists', () async {
        // Given: Valid token exists
        const token = 'valid_token_123';
        when(mockTokenManager.getAccessToken())
            .thenAnswer((_) async => token);
        
        final options = RequestOptions(path: '/api/test');
        final handler = MockRequestInterceptorHandler();
        
        // When: Interceptor processes request
        await authInterceptor.onRequest(options, handler);
        
        // Then: Authorization header added
        verify(handler.next(argThat(
          isA<RequestOptions>().having(
            (o) => o.headers['Authorization'],
            'Authorization header',
            'Bearer $token',
          ),
        ))).called(1);
      });
      
      test('should not add Authorization header when no token', () async {
        // Given: No token exists
        when(mockTokenManager.getAccessToken())
            .thenAnswer((_) async => null);
        
        final options = RequestOptions(path: '/api/test');
        final handler = MockRequestInterceptorHandler();
        
        // When: Interceptor processes request
        await authInterceptor.onRequest(options, handler);
        
        // Then: No Authorization header added
        verify(handler.next(argThat(
          isA<RequestOptions>().having(
            (o) => o.headers['Authorization'],
            'Authorization header',
            isNull,
          ),
        ))).called(1);
      });
      
      test('should skip auth for public endpoints', () async {
        // Given: Public endpoint
        const token = 'valid_token_123';
        when(mockTokenManager.getAccessToken())
            .thenAnswer((_) async => token);
        
        final options = RequestOptions(path: '/api/auth/login');
        final handler = MockRequestInterceptorHandler();
        
        // When: Interceptor processes request
        await authInterceptor.onRequest(options, handler);
        
        // Then: No Authorization header added
        verify(handler.next(argThat(
          isA<RequestOptions>().having(
            (o) => o.headers['Authorization'],
            'Authorization header',
            isNull,
          ),
        ))).called(1);
      });
    });
    
    group('onError', () {
      test('should retry with refresh token on 401', () async {
        // Given: 401 error and valid refresh token
        const refreshToken = 'refresh_token_123';
        const newAccessToken = 'new_access_token_123';
        
        when(mockTokenManager.getRefreshToken())
            .thenAnswer((_) async => refreshToken);
        when(mockTokenManager.refreshTokens())
            .thenAnswer((_) async => true);
        when(mockTokenManager.getAccessToken())
            .thenAnswer((_) async => newAccessToken);
        
        final error = DioException(
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/api/test'),
          ),
          requestOptions: RequestOptions(path: '/api/test'),
        );
        final handler = MockErrorInterceptorHandler();
        
        // When: Interceptor handles error
        await authInterceptor.onError(error, handler);
        
        // Then: Token refreshed and request retried
        verify(mockTokenManager.refreshTokens()).called(1);
        verify(handler.resolve(any)).called(1);
      });
      
      test('should reject when refresh fails', () async {
        // Given: 401 error and refresh fails
        when(mockTokenManager.getRefreshToken())
            .thenAnswer((_) async => 'refresh_token');
        when(mockTokenManager.refreshTokens())
            .thenAnswer((_) async => false);
        
        final error = DioException(
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/api/test'),
          ),
          requestOptions: RequestOptions(path: '/api/test'),
        );
        final handler = MockErrorInterceptorHandler();
        
        // When: Interceptor handles error
        await authInterceptor.onError(error, handler);
        
        // Then: Clear tokens and reject
        verify(mockTokenManager.clearTokens()).called(1);
        verify(handler.reject(error)).called(1);
      });
    });
  });
}