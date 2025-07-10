import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/utils/validation_exception.dart';
import 'package:kioku_navi/widgets/custom_snackbar.dart';

class AuthController extends BaseController {
  /// Form keys for different forms
  final registerFormKey = GlobalKey<FormState>();
  final parentLoginFormKey = GlobalKey<FormState>();
  final studentLoginFormKey = GlobalKey<FormState>();

  /// Text controllers
  final name = TextEditingController(); // For registration
  final email = TextEditingController(); // For all login types and registration
  final dob = TextEditingController(); // For registration
  final password = TextEditingController(); // For all forms
  final passwordConfirmation = TextEditingController(); // For registration

  /// Services - injected by GetX
  late final AuthApi _authApi;

  /// Selected dates for the calendar picker (single date for DOB)
  RxList<DateTime?> selectedDates = <DateTime?>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Get injected services
    _authApi = Get.find<AuthApi>();
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
  Future<void> loginStudent(BuildContext context) async {
    await safeApiCall(
      () async {
        // Validate form - use ValidationException for form validation errors
        if (!studentLoginFormKey.currentState!.validate()) {
          throw ValidationException(
              'Please fill in all required fields correctly');
        }

        // Get input values
        final emailValue = email.text.trim();
        final passwordValue = password.text.trim();

        // Call authentication API (token saving handled automatically)
        final response = await _authApi.loginStudent(emailValue, passwordValue);

        // Extract user data for display
        final data = response['data'] as Map<String, dynamic>;
        final userData = data['user'] as Map<String, dynamic>;

        debugPrint('Student login successful: ${userData['name']}');

        return response;
      },
      context: context,
      loaderMessage: 'Logging in...',
      onSuccess: () {
        // Show success snackbar
        CustomSnackbar.showSuccess(
          title: 'Welcome!',
          message: 'Login successful',
        );
        // Navigate after loader is hidden
        requestNavigation(Routes.CHILD_HOME);
      },
      onError: (error) {
        // Handle business logic errors only (technical errors handled globally)
        // This will ONLY be called for actual API response errors (401, 422, etc.)
        CustomSnackbar.showError(
          title: 'Login Failed',
          message: 'Please check your credentials and try again',
        );
      },
    );
  }

  /// Parent Login Implementation
  Future<void> loginParent(BuildContext context) async {
    await safeApiCall(
      () async {
        // Validate form - use ValidationException for form validation errors
        if (!parentLoginFormKey.currentState!.validate()) {
          throw ValidationException(
              'Please fill in all required fields correctly');
        }

        // Get input values
        final emailValue = email.text.trim();
        final passwordValue = password.text.trim();

        // Call authentication API (token saving handled automatically)
        final response = await _authApi.loginParent(emailValue, passwordValue);

        // Extract user data for display
        final data = response['data'] as Map<String, dynamic>;
        final userData = data['user'] as Map<String, dynamic>;

        debugPrint('Parent login successful: ${userData['name']}');

        return response;
      },
      context: context,
      loaderMessage: 'Logging in...',
      onSuccess: () {
        // Show success snackbar
        CustomSnackbar.showSuccess(
          title: 'Welcome!',
          message: 'Login successful',
        );
        // Navigate after loader is hidden
        requestNavigation(Routes.HOME);
      },
      onError: (error) {
        // Handle business logic errors only (technical errors handled globally)
        // This will ONLY be called for actual API response errors (401, 422, etc.)
        CustomSnackbar.showError(
          title: 'Login Failed',
          message: 'Please check your credentials and try again',
        );
      },
    );
  }

  /// Registration Implementation
  Future<void> onRegister(BuildContext context) async {
    await safeApiCall(
      () async {
        // Validate form - use ValidationException for form validation errors
        if (!registerFormKey.currentState!.validate()) {
          throw ValidationException(
              'Please fill in all required fields correctly');
        }

        // Get input values
        final nameValue = name.text.trim();
        final emailValue = email.text.trim();
        final passwordValue = password.text.trim();
        final passwordConfirmationValue = passwordConfirmation.text.trim();
        final dobValue = dob.text.trim();

        // Call registration API (token saving handled automatically)
        final response = await _authApi.register(
          nameValue,
          emailValue,
          passwordValue,
          passwordConfirmationValue,
          dobValue,
        );

        // Extract user data for display
        final data = response['data'] as Map<String, dynamic>;
        final userData = data['user'] as Map<String, dynamic>;

        debugPrint('Registration successful: ${userData['name']}');

        return response;
      },
      context: context,
      loaderMessage: 'Creating account...',
      onSuccess: () {
        // Show success snackbar
        CustomSnackbar.showSuccess(
          title: 'Account Created!',
          message: 'Welcome to KiokuNavi. Please log in to continue.',
        );
        // Navigate after loader is hidden
        requestNavigation(Routes.ROOT_SCREEN);
      },
      onError: (error) {
        // Handle business logic errors only (technical errors handled globally)
        // This will ONLY be called for actual API response errors (401, 422, etc.)
        CustomSnackbar.showError(
          title: 'Registration Failed',
          message: 'Unable to create account. Please try again',
        );
      },
    );
  }

  /// Forgot Password Implementation
  Future<void> onForgotPassword(BuildContext context) async {
    await safeApiCall(
      () async {
        final emailValue = email.text.trim();

        // Use ValidationException for form validation errors
        if (emailValue.isEmpty) {
          throw ValidationException('Please enter your email address');
        }

        // TODO: Implement forgot password API call when backend is ready
        // This would look like:
        // await _authApi.forgotPassword(emailValue);

        // For now, show success message
        debugPrint('Forgot password would be called for: $emailValue');

        return {'success': true};
      },
      context: context,
      loaderMessage: 'Sending reset email...',
      onSuccess: () {
        // Show success dialog after loader is hidden
        CustomSnackbar.showInfo(
          title: 'Password Reset',
          message: 'If an account exists, you will receive reset instructions.',
        );
      },
      onError: (error) {
        // Handle business logic errors only (technical errors handled globally)
        // This will ONLY be called for actual API response errors (401, 422, etc.)
        CustomSnackbar.showError(
          title: 'Reset Failed',
          message: 'Unable to send reset email. Please try again',
        );
      },
    );
  }

  /// Logout Implementation
  Future<void> logout(BuildContext context) async {
    await safeApiCall(
      () async {
        // Call logout API (token clearing handled automatically)
        await _authApi.logout();

        return {'success': true};
      },
      context: context,
      loaderMessage: 'Logging out...',
      onSuccess: () {
        // Show success snackbar
        CustomSnackbar.showInfo(
          title: 'Goodbye!',
          message: 'You have been logged out successfully',
        );
        // Navigate after loader is hidden
        requestNavigation(Routes.ROOT_SCREEN);
      },
      onError: (error) {
        // Show error snackbar
        CustomSnackbar.showError(
          title: 'Logout Failed',
          message: 'Unable to logout. Please try again',
        );
      },
    );
  }

  /// Get current user data
  Future<Map<String, dynamic>?> getCurrentUser(BuildContext context) async {
    return await safeApiCall(
      () async {
        final userData = await _authApi.getCurrentUser();
        return userData;
      },
      context: context,
      loaderMessage: 'Loading user data...',
      onError: (error) {
        // Show error snackbar
        CustomSnackbar.showError(
          title: 'Load Failed',
          message: 'Unable to load user data',
        );
      },
      // No onSuccess callback needed for data fetching
    );
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    dob.dispose();
    password.dispose();
    passwordConfirmation.dispose();
    super.onClose();
  }
}
