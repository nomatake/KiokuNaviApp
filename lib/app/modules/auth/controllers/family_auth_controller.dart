import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/utils/validation_exception.dart';
import 'package:kioku_navi/widgets/custom_snackbar.dart';
import '../../../../models/auth_models.dart';
import '../../../../models/child_model.dart';
import '../../../../models/family_model.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/device_utils.dart';
import '../../../../utils/pin_validator.dart';

class FamilyAuthController extends BaseController {
  /// Form keys for different authentication flows
  late GlobalKey<FormState> parentPreRegistrationFormKey;
  late GlobalKey<FormState> otpVerificationFormKey;
  late GlobalKey<FormState> parentProfileCompletionFormKey;
  late GlobalKey<FormState> parentLoginFormKey;
  late GlobalKey<FormState> childJoinFormKey;
  late GlobalKey<FormState> childPinSetupFormKey;
  late GlobalKey<FormState> childPinLoginFormKey;

  /// Text controllers for parent authentication
  final email = TextEditingController();
  final otp = TextEditingController();
  final parentName = TextEditingController();
  final password = TextEditingController();
  final passwordConfirmation = TextEditingController();

  /// Text controllers for child authentication
  final joinCode = TextEditingController();
  final childPin = TextEditingController();
  final childPinConfirmation = TextEditingController();

  /// Text controllers for family management
  final childNickname = TextEditingController();
  final childBirthDate = TextEditingController();

  /// State variables
  final selectedRelationship = Rx<RelationshipType?>(null);
  final selectedDeviceMode = Rx<DeviceMode>(DeviceMode.personal);
  final selectedDates = <DateTime?>[].obs;
  final isOtpSent = false.obs;
  final tempToken = ''.obs;
  final provisionalToken = ''.obs;
  final availableChildren = <ChildModel>[].obs;
  final selectedChild = Rx<ChildModel?>(null);

  /// Services
  late final AuthApi _authApi;

  @override
  void onInit() {
    super.onInit();
    _initializeFormKeys();
    _authApi = Get.find<AuthApi>();
  }

  /// Initialize all form keys
  void _initializeFormKeys() {
    parentPreRegistrationFormKey = GlobalKey<FormState>();
    otpVerificationFormKey = GlobalKey<FormState>();
    parentProfileCompletionFormKey = GlobalKey<FormState>();
    parentLoginFormKey = GlobalKey<FormState>();
    childJoinFormKey = GlobalKey<FormState>();
    childPinSetupFormKey = GlobalKey<FormState>();
    childPinLoginFormKey = GlobalKey<FormState>();
  }

  // === Parent Authentication Methods ===

  /// Step 1: Pre-register parent with email
  Future<void> preRegisterParent(BuildContext context) async {
    await safeApiCall(
      () async {
        if (!parentPreRegistrationFormKey.currentState!.validate()) {
          throw ValidationException(
              'Please fill in all required fields correctly');
        }

        final emailValue = email.text.trim();
        final response = await _authApi.preRegisterParent(emailValue);

        debugPrint('Pre-registration successful for: $emailValue');
        return response;
      },
      context: context,
      loaderMessage: 'Sending verification code...',
      onSuccess: () {
        isOtpSent.value = true;
        CustomSnackbar.showSuccess(
          title: 'Code Sent!',
          message: 'Please check your email for the verification code.',
        );

        // Defer navigation to avoid setState during build
        Future.delayed(Duration.zero, () {
          Get.toNamed(Routes.OTP_VERIFICATION);
        });
      },
      onError: (error) {
        CustomSnackbar.showError(
          title: 'Failed to Send Code',
          message: 'Unable to send verification code. Please try again.',
        );
      },
    );
  }

  /// Step 2: Verify OTP
  Future<void> verifyOtp(BuildContext context) async {
    await safeApiCall(
      () async {
        if (!otpVerificationFormKey.currentState!.validate()) {
          throw ValidationException('Please enter the verification code');
        }

        final emailValue = email.text.trim();
        final otpValue = otp.text.trim();
        final result = await _authApi.verifyEmail(emailValue, otpValue);

        tempToken.value = result.provisionalToken ?? '';
        debugPrint('OTP verification successful');
        return result;
      },
      context: context,
      loaderMessage: 'Verifying code...',
      onSuccess: () {
        CustomSnackbar.showSuccess(
          title: 'Email Verified!',
          message: 'Now let\'s complete your profile.',
        );

        // Defer navigation to avoid setState during build
        Future.delayed(Duration.zero, () {
          Get.toNamed(Routes.PARENT_PROFILE_COMPLETION);
        });
      },
      onError: (error) {
        CustomSnackbar.showError(
          title: 'Invalid Code',
          message: 'The verification code is incorrect or expired.',
        );
      },
    );
  }

  /// Step 3: Complete parent profile and create family
  Future<void> completeParentProfile(BuildContext context) async {
    await safeApiCall(
      () async {
        if (!parentProfileCompletionFormKey.currentState!.validate()) {
          throw ValidationException(
              'Please fill in all required fields correctly');
        }

        final profileData = ParentProfileCompletion(
          tempToken: tempToken.value,
          name: parentName.text.trim(),
          password: password.text.trim(),
          passwordConfirmation: passwordConfirmation.text.trim(),
          deviceMode: selectedDeviceMode.value,
        );

        final result = await _authApi.completeParentProfile(profileData);
        debugPrint('Profile completion successful');
        return result;
      },
      context: context,
      loaderMessage: 'Creating your family account...',
      onSuccess: () {
        clearTextControllers();
        CustomSnackbar.showSuccess(
          title: 'Welcome to KiokuNavi!',
          message: 'Your family account has been created successfully.',
        );

        // Defer navigation to avoid setState during build
        Future.delayed(Duration.zero, () {
          Get.offAllNamed(Routes.PARENT_DASHBOARD);
        });
      },
      onError: (error) {
        CustomSnackbar.showError(
          title: 'Account Creation Failed',
          message: 'Unable to create your account. Please try again.',
        );
      },
    );
  }

  /// Parent login
  Future<void> loginParent(BuildContext context) async {
    await safeApiCall(
      () async {
        if (!parentLoginFormKey.currentState!.validate()) {
          throw ValidationException(
              'Please fill in all required fields correctly');
        }

        final emailValue = email.text.trim();
        final passwordValue = password.text.trim();
        final result = await _authApi.loginParent(emailValue, passwordValue);

        debugPrint('Parent login successful');
        return result;
      },
      context: context,
      loaderMessage: 'Signing in...',
      onSuccess: () {
        clearTextControllers();
        CustomSnackbar.showSuccess(
          title: 'Welcome Back!',
          message: 'You have been signed in successfully.',
        );

        // Defer navigation to avoid setState during build
        Future.delayed(Duration.zero, () {
          Get.offAllNamed(Routes.PARENT_DASHBOARD);
        });
      },
      onError: (error) {
        CustomSnackbar.showError(
          title: 'Sign In Failed',
          message: 'Invalid email or password. Please try again.',
        );
      },
    );
  }

  // === Child Authentication Methods ===

  /// Child join with code
  Future<void> joinWithCode(BuildContext context) async {
    await safeApiCall(
      () async {
        if (!childJoinFormKey.currentState!.validate()) {
          throw ValidationException('Please enter the join code');
        }

        final deviceInfo = await DeviceUtils.getDeviceInfo();
        final request = ChildJoinRequest(
          code: joinCode.text.trim(),
          deviceInfo: deviceInfo,
        );

        final result = await _authApi.joinWithCode(request);
        provisionalToken.value = result.provisionalToken ?? '';
        debugPrint('Join with code successful');
        return result;
      },
      context: context,
      loaderMessage: 'Joining family...',
      onSuccess: () {
        CustomSnackbar.showSuccess(
          title: 'Family Found!',
          message: 'Now let\'s set up your secure PIN.',
        );

        // Defer navigation to avoid setState during build
        Future.delayed(Duration.zero, () {
          Get.toNamed(Routes.CHILD_PIN_SETUP);
        });
      },
      onError: (error) {
        CustomSnackbar.showError(
          title: 'Invalid Code',
          message: 'The join code is incorrect or expired.',
        );
      },
    );
  }

  /// Set up child PIN
  Future<void> setChildPin(BuildContext context) async {
    await safeApiCall(
      () async {
        if (!childPinSetupFormKey.currentState!.validate()) {
          throw ValidationException('Please enter and confirm your PIN');
        }

        final pin = childPin.text.trim();
        final pinConfirmation = childPinConfirmation.text.trim();

        // Validate PIN security
        final pinValidationError = PinValidator.validatePin(pin);
        if (pinValidationError != null) {
          throw ValidationException(pinValidationError);
        }

        if (pin != pinConfirmation) {
          throw ValidationException('PINs do not match');
        }

        final pinData = ChildPinSetup(
          provisionalToken: provisionalToken.value,
          pin: pin,
        );

        final result = await _authApi.setChildPin(pinData);
        debugPrint('PIN setup successful');
        return result;
      },
      context: context,
      loaderMessage: 'Setting up your PIN...',
      onSuccess: () {
        clearTextControllers();
        CustomSnackbar.showSuccess(
          title: 'PIN Created!',
          message: 'Your account is ready. Welcome to KiokuNavi!',
        );

        // Defer navigation to avoid setState during build
        Future.delayed(Duration.zero, () {
          Get.offAllNamed(Routes.CHILD_HOME);
        });
      },
      onError: (error) {
        CustomSnackbar.showError(
          title: 'PIN Setup Failed',
          message: 'Unable to create your PIN. Please try again.',
        );
      },
    );
  }

  /// Authenticate child with PIN
  Future<void> authenticateChildWithPin(
      BuildContext context, ChildModel child) async {
    await safeApiCall(
      () async {
        if (!childPinLoginFormKey.currentState!.validate()) {
          throw ValidationException('Please enter your PIN');
        }

        final deviceInfo = await DeviceUtils.getDeviceInfo();
        final pinAuth = ChildPinAuth(
          childId: child.id,
          pin: childPin.text.trim(),
          deviceInfo: deviceInfo,
        );

        final result = await _authApi.authenticateChildWithPin(pinAuth);
        debugPrint('Child PIN authentication successful');
        return result;
      },
      context: context,
      loaderMessage: 'Signing in...',
      onSuccess: () {
        clearTextControllers();
        CustomSnackbar.showSuccess(
          title: 'Welcome back, ${child.nickname}!',
          message: 'You have been signed in successfully.',
        );

        // Defer navigation to avoid setState during build
        Future.delayed(Duration.zero, () {
          Get.offAllNamed(Routes.CHILD_HOME);
        });
      },
      onError: (error) {
        CustomSnackbar.showError(
          title: 'Sign In Failed',
          message: 'Incorrect PIN. Please try again.',
        );
      },
    );
  }

  /// Load children for device (shared device mode)
  Future<void> loadChildrenForDevice(BuildContext context) async {
    await safeApiCall(
      () async {
        final deviceInfo = await DeviceUtils.getDeviceInfo();
        final children =
            await _authApi.getChildrenForDevice(deviceInfo.fingerprint);
        availableChildren.value = children;
        return children;
      },
      context: context,
      loaderMessage: 'Loading profiles...',
      onError: (error) {
        CustomSnackbar.showError(
          title: 'Load Failed',
          message: 'Unable to load child profiles.',
        );
      },
    );
  }

  /// Handle child login flow - checks device mode and routes appropriately
  Future<void> handleChildLogin() async {
    try {
      // Get device info to check for existing children
      final deviceInfo = await DeviceUtils.getDeviceInfo();
      final children =
          await _authApi.getChildrenForDevice(deviceInfo.fingerprint);

      if (children.isEmpty) {
        // No children found on this device
        CustomSnackbar.showError(
          title: 'No Profiles Found',
          message:
              'No child profiles found on this device. Please join a family first.',
        );
        return;
      }

      if (children.length == 1) {
        // Personal device mode - only one child, go directly to PIN login
        selectedChild.value = children.first;
        Future.delayed(Duration.zero, () {
          Get.toNamed(Routes.CHILD_PIN_LOGIN);
        });
      } else {
        // Shared device mode - multiple children, show profile selection
        availableChildren.value = children;
        Future.delayed(Duration.zero, () {
          Get.toNamed(Routes.CHILD_PROFILE_SELECTION);
        });
      }
    } catch (e) {
      // If API call fails, assume personal device and go to PIN login
      debugPrint('Error checking children: $e');
      Future.delayed(Duration.zero, () {
        Get.toNamed(Routes.CHILD_PROFILE_SELECTION);
      });
    }
  }

  // === Helper Methods ===

  /// Format date for display
  String formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  /// Handle date selection from calendar
  void onDateSelected(List<DateTime?> dates) {
    selectedDates.value = dates;
    if (dates.isNotEmpty && dates.first != null) {
      childBirthDate.text = formatDate(dates.first);
    }
  }

  /// Clear all text controllers and reset state
  void clearTextControllers() {
    email.clear();
    otp.clear();
    parentName.clear();
    password.clear();
    passwordConfirmation.clear();
    joinCode.clear();
    childPin.clear();
    childPinConfirmation.clear();
    childNickname.clear();
    childBirthDate.clear();
    selectedDates.clear();
    selectedRelationship.value = null;
    selectedDeviceMode.value = DeviceMode.personal;
    isOtpSent.value = false;
    tempToken.value = '';
    provisionalToken.value = '';
    selectedChild.value = null;

    // Reinitialize form keys
    _initializeFormKeys();
  }

  @override
  void onClose() {
    email.dispose();
    otp.dispose();
    parentName.dispose();
    password.dispose();
    passwordConfirmation.dispose();
    joinCode.dispose();
    childPin.dispose();
    childPinConfirmation.dispose();
    childNickname.dispose();
    childBirthDate.dispose();
    super.onClose();
  }
}
