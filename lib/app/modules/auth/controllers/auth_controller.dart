import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';

class AuthController extends BaseController {
  /// Form keys for different forms
  final registerFormKey = GlobalKey<FormState>();
  final parentLoginFormKey = GlobalKey<FormState>();
  final studentLoginFormKey = GlobalKey<FormState>();

  /// Text controllers
  final email = TextEditingController(); // For all login types and registration
  final dob = TextEditingController(); // For registration
  final password = TextEditingController(); // For all forms

  /// Services - injected by GetX
  late final AuthApi _authApi;
  late final TokenManager _tokenManager;

  /// Selected dates for the calendar picker (single date for DOB)
  RxList<DateTime?> selectedDates = <DateTime?>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Get injected services
    _authApi = Get.find<AuthApi>();
    _tokenManager = Get.find<TokenManager>();
  }

  /// Format date for display
  String formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  /// Handle date selection from calendar
  void onDateSelected(List<DateTime?> dates) {
    selectedDates.value = dates;
    if (dates.isNotEmpty && dates.first != null) {
      dob.text = formatDate(dates.first);
    }
  }

  /// Student Login Implementation (using email and password)
  Future<void> loginStudent() async {
    await safeApiCall(() async {
      // Validate form
      if (!studentLoginFormKey.currentState!.validate()) {
        throw 'Please fill in all required fields correctly';
      }

      // Get input values
      final emailValue = email.text.trim();
      final passwordValue = password.text.trim();

      // Call authentication API
      final response = await _authApi.loginStudent(emailValue, passwordValue);

      // Extract tokens from response
      final accessToken = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String;

      // Save tokens securely
      await _tokenManager.saveTokens(accessToken, refreshToken);

      // Extract user data
      final userData = response['user'] as Map<String, dynamic>;
      print('Student login successful: ${userData['name']}');

      // Navigate to student home
      requestNavigation(Routes.CHILD_HOME);

      return response;
    });
  }

  /// Parent Login Implementation
  Future<void> loginParent() async {
    await safeApiCall(() async {
      // Validate form
      if (!parentLoginFormKey.currentState!.validate()) {
        throw 'Please fill in all required fields correctly';
      }

      // Get input values
      final emailValue = email.text.trim();
      final passwordValue = password.text.trim();

      // Call authentication API
      final response = await _authApi.loginParent(emailValue, passwordValue);

      // Extract tokens from response
      final accessToken = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String;

      // Save tokens securely
      await _tokenManager.saveTokens(accessToken, refreshToken);

      // Extract user data
      final userData = response['user'] as Map<String, dynamic>;
      print('Parent login successful: ${userData['name']}');

      // Navigate to parent home
      requestNavigation(Routes.HOME);

      return response;
    });
  }

  /// Registration Implementation
  Future<void> onRegister() async {
    await safeApiCall(() async {
      // Validate form
      if (!registerFormKey.currentState!.validate()) {
        throw 'Please fill in all required fields correctly';
      }

      // Get input values
      final emailValue = email.text.trim();
      final passwordValue = password.text.trim();
      final dobValue = dob.text.trim();

      if (emailValue.isEmpty || passwordValue.isEmpty || dobValue.isEmpty) {
        throw 'All fields are required';
      }

      // TODO: Implement registration API call when backend is ready
      // This would look like:
      // final response = await _authApi.registerParent(emailValue, passwordValue, dobValue);
      // await _tokenManager.saveTokens(response['access_token'], response['refresh_token']);
      // requestNavigation(Routes.HOME);

      // For now, show success message
      print('Registration would be called with: $emailValue, $dobValue');

      // Navigate to next step or success page
      requestNavigation(Routes.HOME);

      return {'success': true};
    });
  }

  /// Forgot Password Implementation
  Future<void> onForgotPassword() async {
    await safeApiCall(() async {
      final emailValue = email.text.trim();

      if (emailValue.isEmpty) {
        throw 'Please enter your email address';
      }

      // TODO: Implement forgot password API call when backend is ready
      // This would look like:
      // await _authApi.forgotPassword(emailValue);

      // For now, show success message
      print('Forgot password would be called for: $emailValue');

      // Show success dialog or navigate to reset instructions
      Get.snackbar(
        'Password Reset',
        'If an account exists, you will receive reset instructions.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return {'success': true};
    });
  }

  /// Logout Implementation
  Future<void> logout() async {
    await safeApiCall(() async {
      // Call logout API
      await _authApi.logout();

      // Clear stored tokens
      await _tokenManager.clearTokens();

      // Navigate to login screen
      requestNavigation(Routes.ROOT_SCREEN);

      return {'success': true};
    });
  }

  /// Check if user is authenticated
  Future<bool> checkAuthentication() async {
    return await _tokenManager.isAuthenticated();
  }

  /// Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    return await safeApiCall(() async {
      final userData = await _authApi.getCurrentUser();
      return userData;
    });
  }

  @override
  void onClose() {
    email.dispose();
    dob.dispose();
    password.dispose();
    super.onClose();
  }
}
