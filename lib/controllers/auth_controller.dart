import 'package:get/get.dart';
import 'package:kioku_navi/services/auth/login_service.dart';
import 'package:kioku_navi/repositories/user_repository.dart';
import 'package:kioku_navi/models/user.dart';

class AuthController extends GetxController {
  final LoginService loginService;
  final UserRepository userRepository;
  
  // Observable states
  final isAuthenticated = false.obs;
  final currentUser = Rxn<User>();
  final isLoading = false.obs;
  final error = Rxn<String>();
  
  AuthController({
    required this.loginService,
    required this.userRepository,
  });
  
  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }
  
  Future<void> _restoreSession() async {
    try {
      final user = await userRepository.getCurrentUser();
      if (user != null) {
        currentUser.value = user;
        isAuthenticated.value = true;
      }
    } catch (e) {
      // Failed to restore session
      print('Failed to restore session: $e');
    }
  }
  
  Future<bool> loginStudent({
    required String studentId,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;
      
      final user = await loginService.loginStudent(
        studentId: studentId,
        password: password,
      );
      
      await userRepository.saveUser(user);
      
      currentUser.value = user;
      isAuthenticated.value = true;
      
      return true;
    } on LoginException catch (e) {
      error.value = e.message;
      return false;
    } catch (e) {
      error.value = 'An unexpected error occurred';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<bool> loginParent({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;
      
      final user = await loginService.loginParent(
        email: email,
        password: password,
      );
      
      await userRepository.saveUser(user);
      
      currentUser.value = user;
      isAuthenticated.value = true;
      
      return true;
    } on LoginException catch (e) {
      error.value = e.message;
      return false;
    } catch (e) {
      error.value = 'An unexpected error occurred';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      await loginService.logout();
      await userRepository.clearUser();
      
      currentUser.value = null;
      isAuthenticated.value = false;
      error.value = null;
    } finally {
      isLoading.value = false;
    }
  }
  
  void clearError() {
    error.value = null;
  }
}