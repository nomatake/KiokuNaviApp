import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/utils/validation_exception.dart';
import 'package:kioku_navi/widgets/custom_snackbar.dart';

class AuthController extends BaseController {
  /// Form keys for different forms - recreated to avoid duplicate key issues
  late GlobalKey<FormState> registerFormKey;
  late GlobalKey<FormState> parentLoginFormKey;
  late GlobalKey<FormState> studentLoginFormKey;

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

    // Initialize form keys
    _initializeFormKeys();

    // Get injected services
    _authApi = Get.find<AuthApi>();
  }

  /// Initialize or reinitialize form keys to avoid duplicate key issues
  void _initializeFormKeys() {
    registerFormKey = GlobalKey<FormState>();
    parentLoginFormKey = GlobalKey<FormState>();
    studentLoginFormKey = GlobalKey<FormState>();
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
      loaderMessage: LocaleKeys.common_messages_loggingIn.tr,
      onSuccess: () {
        // Show success snackbar
        CustomSnackbar.showSuccess(
          title: LocaleKeys.common_messages_welcome.tr,
          message: LocaleKeys.common_messages_loginSuccessful.tr,
        );
        // Clear text controllers after successful login
        clearTextControllers();
        // Navigate after loader is hidden
        Get.toNamed(Routes.CHILD_HOME);
      },
      onError: (error) {
        // Handle business logic errors only (technical errors handled globally)
        // This will ONLY be called for actual API response errors (401, 422, etc.)
        CustomSnackbar.showError(
          title: LocaleKeys.common_messages_loginFailed.tr,
          message: LocaleKeys.common_messages_checkCredentials.tr,
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
      loaderMessage: LocaleKeys.common_messages_loggingIn.tr,
      onSuccess: () {
        // Show success snackbar
        CustomSnackbar.showSuccess(
          title: LocaleKeys.common_messages_welcome.tr,
          message: LocaleKeys.common_messages_loginSuccessful.tr,
        );
        // Clear text controllers after successful login
        clearTextControllers();
        // Navigate after loader is hidden
        Get.toNamed(Routes.TUTORIAL);
      },
      onError: (error) {
        // Handle business logic errors only (technical errors handled globally)
        // This will ONLY be called for actual API response errors (401, 422, etc.)
        CustomSnackbar.showError(
          title: LocaleKeys.common_messages_loginFailed.tr,
          message: LocaleKeys.common_messages_checkCredentials.tr,
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
      loaderMessage: LocaleKeys.common_messages_creatingAccount.tr,
      onSuccess: () {
        // Show success snackbar
        CustomSnackbar.showSuccess(
          title: LocaleKeys.common_messages_accountCreated.tr,
          message: LocaleKeys.common_messages_welcomeToKiokuNavi.tr,
        );
        // Clear text controllers after successful registration
        clearTextControllers();
        // Navigate after loader is hidden
        Get.toNamed(Routes.ROOT_SCREEN);
      },
      onError: (error) {
        // Handle business logic errors only (technical errors handled globally)
        // This will ONLY be called for actual API response errors (401, 422, etc.)
        CustomSnackbar.showError(
          title: LocaleKeys.common_messages_registrationFailed.tr,
          message: LocaleKeys.common_messages_unableToCreateAccount.tr,
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
      loaderMessage: LocaleKeys.common_messages_sendingResetEmail.tr,
      onSuccess: () {
        // Show success dialog after loader is hidden
        CustomSnackbar.showInfo(
          title: LocaleKeys.common_messages_passwordReset.tr,
          message: LocaleKeys.common_messages_resetInstructions.tr,
        );
      },
      onError: (error) {
        // Handle business logic errors only (technical errors handled globally)
        // This will ONLY be called for actual API response errors (401, 422, etc.)
        CustomSnackbar.showError(
          title: LocaleKeys.common_messages_resetFailed.tr,
          message: LocaleKeys.common_messages_unableToSendResetEmail.tr,
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
      loaderMessage: LocaleKeys.common_messages_loggingOut.tr,
      onSuccess: () {
        // Show success snackbar
        CustomSnackbar.showInfo(
          title: LocaleKeys.common_messages_goodbye.tr,
          message: LocaleKeys.common_messages_loggedOutSuccessfully.tr,
        );
        // Clear text controllers after successful logout
        clearTextControllers();
        // Navigate after loader is hidden
        Get.toNamed(Routes.ROOT_SCREEN);
      },
      onError: (error) {
        // Show error snackbar
        CustomSnackbar.showError(
          title: LocaleKeys.common_messages_logoutFailed.tr,
          message: LocaleKeys.common_messages_unableToLogout.tr,
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
      loaderMessage: LocaleKeys.common_messages_loadingUserData.tr,
      onError: (error) {
        // Show error snackbar
        CustomSnackbar.showError(
          title: LocaleKeys.common_messages_loadFailed.tr,
          message: LocaleKeys.common_messages_unableToLoadUserData.tr,
        );
      },
      // No onSuccess callback needed for data fetching
    );
  }

  /// Clear all text controllers and reinitialize form keys
  void clearTextControllers() {
    name.clear();
    email.clear();
    dob.clear();
    password.clear();
    passwordConfirmation.clear();
    selectedDates.clear();
    
    // Reinitialize form keys to avoid duplicate key issues
    _initializeFormKeys();
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
