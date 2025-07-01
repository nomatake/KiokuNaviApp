import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/models/user.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:get/get.dart';

class LoginException implements Exception {
  final String message;
  LoginException(this.message);
}

class LoginService extends GetxService {
  final AuthApi authApi;
  final TokenManager tokenManager;
  
  // Observable user state
  final Rxn<User> currentUser = Rxn<User>();
  
  // Login attempt tracking
  int _failedAttempts = 0;
  DateTime? _lockoutTime;
  
  static const int maxAttempts = 3;
  static const Duration lockoutDuration = Duration(minutes: 5);
  
  LoginService({
    required this.authApi,
    required this.tokenManager,
  });
  
  bool get isLocked {
    if (_lockoutTime == null) return false;
    if (DateTime.now().isAfter(_lockoutTime!)) {
      _lockoutTime = null;
      _failedAttempts = 0;
      return false;
    }
    return true;
  }
  
  Duration get lockoutRemaining {
    if (_lockoutTime == null) return Duration.zero;
    final remaining = _lockoutTime!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
  
  Future<User> loginStudent({
    required String studentId,
    required String password,
  }) async {
    // Check lockout
    if (isLocked) {
      throw LoginException(
        'Too many failed attempts. Try again in ${lockoutRemaining.inMinutes} minutes',
      );
    }
    
    try {
      final response = await authApi.loginStudent(studentId, password);
      
      // Save tokens
      await tokenManager.saveAccessToken(response['access_token']);
      await tokenManager.saveRefreshToken(response['refresh_token']);
      
      // Create and cache user
      final user = User.fromJson(response['user']);
      currentUser.value = user;
      
      // Reset failed attempts
      _failedAttempts = 0;
      _lockoutTime = null;
      
      return user;
    } on UnauthorizedException {
      _handleFailedAttempt();
      throw LoginException('Invalid student ID or password');
    } catch (e) {
      if (e is! LoginException) {
        throw LoginException('Login failed. Please check your connection and try again.');
      }
      rethrow;
    }
  }
  
  Future<User> loginParent({
    required String email,
    required String password,
  }) async {
    // Check lockout
    if (isLocked) {
      throw LoginException(
        'Too many failed attempts. Try again in ${lockoutRemaining.inMinutes} minutes',
      );
    }
    
    try {
      final response = await authApi.loginParent(email, password);
      
      // Save tokens
      await tokenManager.saveAccessToken(response['access_token']);
      await tokenManager.saveRefreshToken(response['refresh_token']);
      
      // Create and cache user
      final user = User.fromJson(response['user']);
      currentUser.value = user;
      
      // Reset failed attempts
      _failedAttempts = 0;
      _lockoutTime = null;
      
      return user;
    } on UnauthorizedException {
      _handleFailedAttempt();
      throw LoginException('Invalid email or password');
    } catch (e) {
      if (e is! LoginException) {
        throw LoginException('Login failed. Please check your connection and try again.');
      }
      rethrow;
    }
  }
  
  void _handleFailedAttempt() {
    _failedAttempts++;
    if (_failedAttempts >= maxAttempts) {
      _lockoutTime = DateTime.now().add(lockoutDuration);
    }
  }
  
  Future<void> logout() async {
    try {
      await authApi.logout();
    } catch (e) {
      // Log error but continue with local cleanup
      print('Logout API error: $e');
    } finally {
      await tokenManager.clearTokens();
      currentUser.value = null;
    }
  }
  
  Future<User?> getCurrentUser() async {
    if (currentUser.value != null) {
      return currentUser.value;
    }
    
    // Try to fetch user if authenticated
    if (await tokenManager.isAuthenticated()) {
      try {
        final response = await authApi.getCurrentUser();
        final user = User.fromJson(response);
        currentUser.value = user;
        return user;
      } catch (e) {
        // Token might be invalid
        await logout();
        return null;
      }
    }
    
    return null;
  }
  
  @override
  void onInit() {
    super.onInit();
    // Try to restore user session on service initialization
    getCurrentUser();
  }
}