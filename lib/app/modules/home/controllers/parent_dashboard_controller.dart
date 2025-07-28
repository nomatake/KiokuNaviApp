import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/models/child_model.dart';
import 'package:kioku_navi/models/family_model.dart';
import 'package:kioku_navi/models/auth_models.dart';
import 'package:kioku_navi/models/user_model.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
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
    // For data loading without user interaction, we can use Get.context
    final context = Get.context;
    if (context == null) return;

    await safeApiCall(
      () async {
        final response = await _authApi.getFamilyInfo();

        // Extract family data
        final data = response['data'] as Map<String, dynamic>;
        final familyData = data['family'] as Map<String, dynamic>;
        final childrenData = data['children'] as List<dynamic>;
        final userData = data['user'] as Map<String, dynamic>;

        familyInfo.value = FamilyModel.fromJson(familyData);
        user.value = UserModel.fromJson(userData);
        children.value = childrenData
            .map((child) => ChildModel.fromJson(child as Map<String, dynamic>))
            .toList();

        return response;
      },
      context: context,
      loaderMessage: 'Loading family data...',
      onError: (error) {
        CustomSnackbar.showError(
          title: 'Load Failed',
          message: 'Unable to load family information.',
        );
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

        // Add to local list
        children.add(newChild);

        return newChild;
      },
      context: context,
      loaderMessage: 'Adding child...',
      onSuccess: () {
        // Clear form only on success
        childNickname.clear();
        childBirthDate.clear();

        CustomSnackbar.showSuccess(
          title: 'Child Added!',
          message: 'Child has been added to your family.',
        );
        Get.back(); // Close dialog
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
        final joinCode = await _authApi.generateJoinCode(child.id);

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
      AlertDialog(
        title: const Text('Add Child'),
        content: Form(
          key: addChildFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: childNickname,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  hintText: 'Enter child\'s nickname',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a nickname';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: childBirthDate,
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  hintText: 'Tap to select date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectBirthDate,
                validator: (value) {
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
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: addChild,
            child: const Text('Add Child'),
          ),
        ],
      ),
    );
  }

  /// Select birth date using date picker
  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    final selectedDate = await Get.dialog<DateTime>(
      DatePickerDialog(
        initialDate: DateTime(
            now.year - 8, now.month, now.day), // Default to 8 years old
        firstDate: DateTime(now.year - 17, now.month, now.day), // Just under 18
        lastDate: now, // Cannot be in the future
      ),
    );

    if (selectedDate != null) {
      childBirthDate.text =
          selectedDate.toIso8601String().split('T')[0]; // YYYY-MM-DD format
    }
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
