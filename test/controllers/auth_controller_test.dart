import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/controllers/auth_controller.dart';
import 'package:kioku_navi/services/auth/login_service.dart';
import 'package:kioku_navi/repositories/user_repository.dart';
import 'package:kioku_navi/models/user.dart';

@GenerateNiceMocks([MockSpec<LoginService>(), MockSpec<UserRepository>()])
import 'auth_controller_test.mocks.dart';

void main() {
  group('AuthController', () {
    late AuthController authController;
    late MockLoginService mockLoginService;
    late MockUserRepository mockUserRepository;
    
    setUp(() {
      Get.testMode = true;
      mockLoginService = MockLoginService();
      mockUserRepository = MockUserRepository();
      
      authController = AuthController(
        loginService: mockLoginService,
        userRepository: mockUserRepository,
      );
    });
    
    tearDown(() {
      Get.reset();
    });
    
    group('Authentication State', () {
      test('should initialize as not authenticated', () {
        // Then: Initial state is not authenticated
        expect(authController.isAuthenticated.value, isFalse);
        expect(authController.currentUser.value, isNull);
        expect(authController.isLoading.value, isFalse);
      });
      
      test('should restore user session on init', () async {
        // Given: Saved user in repository
        final savedUser = User(
          id: 1,
          name: '山田太郎',
          type: UserType.student,
          studentId: 'STU001',
          grade: 5,
        );
        
        when(mockUserRepository.getCurrentUser())
            .thenAnswer((_) async => savedUser);
        
        // When: Initialize controller
        authController.onInit();
        await Future.delayed(Duration(milliseconds: 100));
        
        // Then: User is restored
        expect(authController.isAuthenticated.value, isTrue);
        expect(authController.currentUser.value?.id, equals(savedUser.id));
      });
    });
    
    group('Student Login', () {
      test('should login student successfully', () async {
        // Given: Valid credentials
        const studentId = 'STU001';
        const password = 'password123';
        final user = User(
          id: 1,
          name: '山田太郎',
          type: UserType.student,
          studentId: studentId,
          grade: 5,
        );
        
        when(mockLoginService.loginStudent(
          studentId: studentId,
          password: password,
        )).thenAnswer((_) async => user);
        
        when(mockUserRepository.saveUser(any))
            .thenAnswer((_) async => {});
        
        // When: Login student
        final result = await authController.loginStudent(
          studentId: studentId,
          password: password,
        );
        
        // Then: Login successful
        expect(result, isTrue);
        expect(authController.isAuthenticated.value, isTrue);
        expect(authController.currentUser.value?.studentId, equals(studentId));
        expect(authController.error.value, isNull);
        verify(mockUserRepository.saveUser(user)).called(1);
      });
      
      test('should handle login failure', () async {
        // Given: Invalid credentials
        const studentId = 'INVALID';
        const password = 'wrong';
        
        when(mockLoginService.loginStudent(
          studentId: studentId,
          password: password,
        )).thenThrow(LoginException('Invalid credentials'));
        
        // When: Login student
        final result = await authController.loginStudent(
          studentId: studentId,
          password: password,
        );
        
        // Then: Login failed
        expect(result, isFalse);
        expect(authController.isAuthenticated.value, isFalse);
        expect(authController.currentUser.value, isNull);
        expect(authController.error.value, contains('Invalid credentials'));
      });
    });
    
    group('Logout', () {
      test('should logout successfully', () async {
        // Given: User is logged in
        final user = User(
          id: 1,
          name: '山田太郎',
          type: UserType.student,
          studentId: 'STU001',
          grade: 5,
        );
        authController.currentUser.value = user;
        authController.isAuthenticated.value = true;
        
        when(mockLoginService.logout()).thenAnswer((_) async => {});
        when(mockUserRepository.clearUser()).thenAnswer((_) async => {});
        
        // When: Logout
        await authController.logout();
        
        // Then: User is logged out
        expect(authController.isAuthenticated.value, isFalse);
        expect(authController.currentUser.value, isNull);
        verify(mockLoginService.logout()).called(1);
        verify(mockUserRepository.clearUser()).called(1);
      });
    });
    
    group('Loading State', () {
      test('should manage loading state during login', () async {
        // Given: Login setup
        const studentId = 'STU001';
        const password = 'password123';
        final user = User(
          id: 1,
          name: '山田太郎',
          type: UserType.student,
          studentId: studentId,
          grade: 5,
        );
        
        when(mockLoginService.loginStudent(
          studentId: studentId,
          password: password,
        )).thenAnswer((_) async {
          // Simulate delay
          await Future.delayed(Duration(milliseconds: 100));
          return user;
        });
        
        when(mockUserRepository.saveUser(any))
            .thenAnswer((_) async => {});
        
        // When: Login and check loading state
        expect(authController.isLoading.value, isFalse);
        
        final loginFuture = authController.loginStudent(
          studentId: studentId,
          password: password,
        );
        
        // Then: Loading state changes
        expect(authController.isLoading.value, isTrue);
        
        await loginFuture;
        
        expect(authController.isLoading.value, isFalse);
      });
    });
  });
}