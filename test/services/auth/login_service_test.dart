import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kioku_navi/services/auth/login_service.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/models/user.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';

@GenerateNiceMocks([MockSpec<AuthApi>(), MockSpec<TokenManager>()])
import 'login_service_test.mocks.dart';

void main() {
  group('LoginService', () {
    late LoginService loginService;
    late MockAuthApi mockAuthApi;
    late MockTokenManager mockTokenManager;
    
    setUp(() {
      mockAuthApi = MockAuthApi();
      mockTokenManager = MockTokenManager();
      loginService = LoginService(
        authApi: mockAuthApi,
        tokenManager: mockTokenManager,
      );
    });
    
    group('Student Login', () {
      test('should login student successfully', () async {
        // Given: Valid credentials and API response
        const studentId = 'STU001';
        const password = 'password123';
        final loginResponse = {
          'access_token': 'access_123',
          'refresh_token': 'refresh_123',
          'user': {
            'id': 1,
            'student_id': studentId,
            'name': '山田太郎',
            'grade': 5,
            'type': 'student',
          },
        };
        
        when(mockAuthApi.loginStudent(studentId, password))
            .thenAnswer((_) async => loginResponse);
        
        // When: Login student
        final result = await loginService.loginStudent(
          studentId: studentId,
          password: password,
        );
        
        // Then: Tokens saved and user returned
        expect(result, isA<User>());
        expect(result.studentId, equals(studentId));
        expect(result.type, equals(UserType.student));
        
        verify(mockTokenManager.saveAccessToken('access_123')).called(1);
        verify(mockTokenManager.saveRefreshToken('refresh_123')).called(1);
      });
      
      test('should throw exception on invalid credentials', () async {
        // Given: Invalid credentials
        const studentId = 'INVALID';
        const password = 'wrong';
        
        when(mockAuthApi.loginStudent(studentId, password))
            .thenThrow(UnauthorizedException());
        
        // When/Then: Expect LoginException
        expect(
          () => loginService.loginStudent(
            studentId: studentId,
            password: password,
          ),
          throwsA(isA<LoginException>().having(
            (e) => e.message,
            'message',
            contains('Invalid student ID or password'),
          )),
        );
      });
    });
    
    group('Parent Login', () {
      test('should login parent successfully', () async {
        // Given: Valid email/password and API response
        const email = 'parent@example.com';
        const password = 'password123';
        final loginResponse = {
          'access_token': 'access_456',
          'refresh_token': 'refresh_456',
          'user': {
            'id': 2,
            'email': email,
            'name': '山田花子',
            'type': 'parent',
            'children': [
              {'id': 1, 'name': '山田太郎', 'grade': 5},
            ],
          },
        };
        
        when(mockAuthApi.loginParent(email, password))
            .thenAnswer((_) async => loginResponse);
        
        // When: Login parent
        final result = await loginService.loginParent(
          email: email,
          password: password,
        );
        
        // Then: Tokens saved and user returned
        expect(result, isA<User>());
        expect(result.email, equals(email));
        expect(result.type, equals(UserType.parent));
        expect(result.children?.length, equals(1));
        
        verify(mockTokenManager.saveAccessToken('access_456')).called(1);
        verify(mockTokenManager.saveRefreshToken('refresh_456')).called(1);
      });
    });
    
    group('Logout', () {
      test('should logout successfully', () async {
        // Given: User is logged in
        when(mockAuthApi.logout()).thenAnswer((_) async => {});
        
        // When: Logout
        await loginService.logout();
        
        // Then: Tokens cleared
        verify(mockTokenManager.clearTokens()).called(1);
        verify(mockAuthApi.logout()).called(1);
      });
    });
  });
}