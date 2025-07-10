import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/services/connectivity/connectivity_manager.dart';
import 'package:kioku_navi/utils/api_error_handler.dart';
import 'package:kioku_navi/utils/navigation_helper.dart';
import 'package:kioku_navi/utils/validation_exception.dart';
import 'package:kioku_navi/widgets/custom_loader.dart';

abstract class BaseController extends GetxController with NavigationHelper {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool hasError = false.obs;

  /// Enhanced safeApiCall with CustomLoader integration
  /// [apiCall] - The API function to execute
  /// [context] - BuildContext for showing loader (required)
  /// [loaderMessage] - Message to show in loader (optional)
  /// [useLoader] - Whether to show visual loader (default: true)
  /// [onSuccess] - Callback to execute after successful API call (for navigation)
  /// [onError] - Callback to execute when API call fails (for error handling)
  Future<T?> safeApiCall<T>(
    Future<T> Function() apiCall, {
    required BuildContext context,
    String? loaderMessage,
    bool? useLoader,
    VoidCallback? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    // Check connectivity FIRST, before showing loader
    try {
      final connectivityManager = Get.find<ConnectivityManager>();
      final isConnected =
          await connectivityManager.checkAndShowNoInternetIfNeeded();

      if (!isConnected) {
        // No internet - bottom sheet is already shown, don't proceed with API call
        return null;
      }
    } catch (e) {
      // Continue with API call if connectivity manager is not available
      debugPrint('Warning: Could not check connectivity: $e');
    }

    bool loaderShown = false;

    try {
      // Set loading state
      isLoading.value = true;
      error.value = '';
      hasError.value = false;

      // Show visual loader if useLoader is not false
      final shouldShowLoader = useLoader ?? true;
      if (shouldShowLoader && context.mounted) {
        CustomLoader.showLoader(context, loaderMessage);
        loaderShown = true;
      }

      // Execute API call
      final result = await apiCall();

      // Hide loader BEFORE executing success callback (navigation)
      if (loaderShown && context.mounted) {
        CustomLoader.hideLoader();
        loaderShown = false;
        // Small delay to ensure smooth UX transition
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Execute success callback (like navigation) after loader is hidden
      onSuccess?.call();

      return result;
    } catch (e) {
      error.value = e.toString();
      hasError.value = true;
      debugPrint('API Error: $e');

      // Hide loader BEFORE handling error
      if (loaderShown && context.mounted) {
        CustomLoader.hideLoader();
        loaderShown = false;
        // Small delay to ensure smooth UX transition
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Handle different types of errors using utility
      if (e is ValidationException) {
        // Form validation errors - don't call onError, just return null
        // The form itself should show validation messages
        return null;
      } else if (ApiErrorHandler.isTechnicalError(e)) {
        // Technical/Network errors - show global snackbar
        ApiErrorHandler.showTechnicalErrorSnackbar(e);
        // Don't call controller's onError for technical issues
      } else {
        // API response errors (4xx, 5xx) - let controller handle
        onError?.call(e);
      }

      return null;
    } finally {
      // Hide loading state
      isLoading.value = false;

      // Hide visual loader if it wasn't already hidden
      if (loaderShown && context.mounted) {
        CustomLoader.hideLoader();
      }
    }
  }

  Future<T?> safeCall<T>(Future<T> Function() call,
      {String? errorMessage}) async {
    try {
      clearError();
      return await call();
    } catch (e) {
      final message = errorMessage ?? 'An error occurred: ${e.toString()}';
      error.value = message;
      hasError.value = true;
      debugPrint('Safe Call Error: $e');
      return null;
    }
  }

  void handleError(dynamic error, {String? customMessage}) {
    final message = customMessage ?? error.toString();
    this.error.value = message;
    hasError.value = true;
    debugPrint('Controller Error: $error');
  }

  void clearError() {
    error.value = '';
    hasError.value = false;
  }

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }

  // Delegate error utility methods to ApiErrorHandler for convenience
  DioException? getDioException(dynamic error) =>
      ApiErrorHandler.getDioException(error);
  bool hasStatusCode(dynamic error, int statusCode) =>
      ApiErrorHandler.hasStatusCode(error, statusCode);
  dynamic getErrorResponseData(dynamic error) =>
      ApiErrorHandler.getErrorResponseData(error);
  String? getServerErrorMessage(dynamic error) =>
      ApiErrorHandler.getServerErrorMessage(error);

  @override
  void onClose() {
    clearNavigation();
    super.onClose();
  }
}
