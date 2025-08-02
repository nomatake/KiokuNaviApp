import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';
import 'package:kioku_navi/widgets/custom_date_picker_form_field.dart';

import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/models/child_model.dart';
import 'package:kioku_navi/models/family_model.dart';
import 'package:kioku_navi/models/auth_models.dart';
import 'package:kioku_navi/models/user_model.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/api/auth_api_impl.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:kioku_navi/utils/api_error_handler.dart';
import 'package:kioku_navi/widgets/custom_snackbar.dart';

class ParentDashboardController extends BaseController {
  // Form keys
  late GlobalKey<FormState> addChildFormKey;

  // Text controllers
  final childNickname = TextEditingController();
  final childBirthDate = TextEditingController();

  // Reactive variables
  final familyInfo = Rx<FamilyModel?>(null);
  final children = <ChildModel>[].obs;
  final user = Rx<UserModel?>(null);
  final isLoading = false.obs;
  final joinCodes = <int, JoinCode>{}.obs; // childId -> JoinCode
  final selectedDates = <DateTime?>[].obs;

  // Prevent duplicate API calls
  bool _isLoadingFamilyData = false;

  // Services
  late final AuthApi _authApi;

  @override
  void onInit() {
    super.onInit();
    _initializeFormKeys();
    _authApi = Get.find<AuthApi>();
    loadFamilyData();
  }

  void _initializeFormKeys() {
    addChildFormKey = GlobalKey<FormState>();
  }

  /// Load family information and children
  Future<void> loadFamilyData() async {
    // Prevent duplicate calls
    if (_isLoadingFamilyData) {
      return;
    }

    // For data loading without user interaction, we can use Get.context
    final context = Get.context;
    if (context == null) return;

    // Add small delay to ensure token save operation has completed
    await Future.delayed(const Duration(milliseconds: 100));

    _isLoadingFamilyData = true;

    await safeApiCall(
      () async {
        final response = await _authApi.getFamilyInfo();

        // Extract family data
        final data = response['data'] as Map<String, dynamic>;
        final familyData = data['family'] as Map<String, dynamic>;
        final childrenData = data['children'] as List<dynamic>;

        familyInfo.value = FamilyModel.fromJson(familyData);

        // User data might not be in family endpoint response, get from storage instead
        final storedUserData = Get.find<GetStorage>().read('user_data');
        if (storedUserData != null) {
          user.value =
              UserModel.fromJson(storedUserData as Map<String, dynamic>);
        }

        children.value = childrenData
            .map((child) => ChildModel.fromJson(child as Map<String, dynamic>))
            .toList();

        return response;
      },
      context: context,
      loaderMessage: 'Loading family data...',
      onSuccess: () {
        _isLoadingFamilyData = false;
      },
      onError: (error) {
        // Only show error if we're not in a silent refresh
        CustomSnackbar.showError(
          title: 'Load Failed',
          message: 'Unable to load family information.',
        );

        // Don't let this cause navigation issues
        debugPrint('Family data load error: $error');
        _isLoadingFamilyData = false;
      },
    );
  }

  /// Add a new child to the family
  Future<void> addChild() async {
    if (!addChildFormKey.currentState!.validate()) {
      return;
    }

    final context = Get.context;
    if (context == null) return;

    await safeApiCall(
      () async {
        final nickname = childNickname.text.trim();
        final birthDate = DateTime.parse(childBirthDate.text);

        final newChild = await _authApi.addChild(nickname, birthDate);

        // Add the new child to local list immediately
        children.add(newChild);

        // Reset the loading flag to allow immediate refresh
        _isLoadingFamilyData = false;

        // Try to refresh family data, but don't fail if it errors
        try {
          await loadFamilyData();
        } catch (e) {
          // If family data refresh fails, just log it but don't throw error
          debugPrint('Family data refresh failed after adding child: $e');
        }

        return true;
      },
      context: context,
      loaderMessage: 'Adding child...',
      onSuccess: () {
        CustomSnackbar.showSuccess(
          title: 'Child Added!',
          message: 'Child has been added to your family.',
        );
        Get.back(); // Close dialog
        // Reset form after successful API call and dialog close
        _resetAddChildForm();
      },
      onError: (error) {
        // Extract specific validation message from API response
        String errorMessage = 'Unable to add child to family.';

        if (error is ApiException && error.statusCode == 422) {
          // Try to get the specific validation message
          final serverMessage = ApiErrorHandler.getServerErrorMessage(error);
          if (serverMessage != null && serverMessage.isNotEmpty) {
            errorMessage = serverMessage;
          }
        }

        CustomSnackbar.showError(
          title: 'Validation Error',
          message: errorMessage,
        );
        // Note: Don't close dialog on validation error so user can correct the input
      },
    );
  }

  /// Generate join code for a child
  Future<void> generateJoinCode(ChildModel child) async {
    final context = Get.context;
    if (context == null) return;

    await safeApiCall(
      () async {
        // Use the new method that includes child nickname
        final joinCode = await (_authApi as AuthApiImpl)
            .generateJoinCodeWithNickname(child.id, child.nickname);

        // Store join code
        joinCodes[child.id] = joinCode;

        return joinCode;
      },
      context: context,
      loaderMessage: 'Generating join code...',
      onSuccess: () {
        CustomSnackbar.showSuccess(
          title: 'Join Code Generated!',
          message: 'Share this code with ${child.nickname}.',
        );
      },
      onError: (error) {
        CustomSnackbar.showError(
          title: 'Failed to Generate Code',
          message: 'Unable to generate join code.',
        );
      },
    );
  }

  /// Remove a child from the family
  Future<void> removeChild(ChildModel child) async {
    final context = Get.context;
    if (context == null) return;

    await safeApiCall(
      () async {
        await _authApi.removeChild(child.id);

        // Remove from local list
        children.removeWhere((c) => c.id == child.id);
        joinCodes.remove(child.id);

        return true;
      },
      context: context,
      loaderMessage: 'Removing child...',
      onSuccess: () {
        CustomSnackbar.showSuccess(
          title: 'Child Removed',
          message: '${child.nickname} has been removed from the family.',
        );
      },
      onError: (error) {
        CustomSnackbar.showError(
          title: 'Failed to Remove Child',
          message: 'Unable to remove child from family.',
        );
      },
    );
  }

  /// Get join code for a child if available
  JoinCode? getJoinCode(int childId) {
    return joinCodes[childId];
  }

  /// Check if child has an active join code
  bool hasActiveJoinCode(int childId) {
    final code = joinCodes[childId];
    return code != null && !code.isExpired;
  }

  /// Show add child dialog
  void showAddChildDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(k4Double.wp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Add Child',
                style: TextStyle(
                  fontSize: k14Double.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: k2Double.hp),
              
              // Form
              Form(
                key: addChildFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nickname Field
                    CustomTextFormField(
                      textController: childNickname,
                      labelText: 'Nickname',
                      hintText: 'Enter child\'s nickname',
                      textInputAction: TextInputAction.next,
                      customValidators: [
                        FormBuilderValidators.required(
                            errorText: 'Please enter a nickname'),
                      ],
                    ),
                    SizedBox(height: k1_5Double.hp),
                    
                    // Birth Date Field
                    CustomDatePickerFormField(
                      textController: childBirthDate,
                      selectedDates: selectedDates,
                      onDateSelected: onDateSelected,
                      labelText: 'Birth Date',
                      hintText: 'Tap to select date',
                      primaryColor: const Color(0xFF2E7D32),
                      customValidators: [
                        FormBuilderValidators.required(
                            errorText: 'Please select birth date'),
                        (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please select birth date';
                          }
                          try {
                            final birthDate = DateTime.parse(value);
                            final age = calculateAge(birthDate);
                            if (age >= 18) {
                              return 'Child must be under 18 years old';
                            }
                            return null;
                          } catch (e) {
                            return 'Please select a valid date';
                          }
                        },
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: k3Double.hp),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: EdgeInsets.symmetric(
                          vertical: k1Double.hp,
                          horizontal: k2Double.wp,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: k10Double.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: k4Double.wp),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: addChild,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        padding: EdgeInsets.symmetric(
                          vertical: k1Double.hp,
                          horizontal: k2Double.wp,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add Child',
                        style: TextStyle(
                          fontSize: k10Double.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    ).then((_) {
      // Reset form when dialog is dismissed by tapping outside or back button
      _resetAddChildForm();
    });
  }

  /// Handle date selection for child birth date
  void onDateSelected(List<DateTime?> dates) {
    if (dates.isNotEmpty && dates.first != null) {
      selectedDates.value = dates;
      childBirthDate.text = dates.first!.toIso8601String().split('T')[0];
    }
  }

  /// Reset add child form fields
  void _resetAddChildForm() {
    // Set controller values to empty strings instead of clearing
    childNickname.text = '';
    childBirthDate.text = '';  
    selectedDates.value = [];
  }

  /// Calculate age from birth date
  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  void onClose() {
    childNickname.dispose();
    childBirthDate.dispose();
    super.onClose();
  }
}
