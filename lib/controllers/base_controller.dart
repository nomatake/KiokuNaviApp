import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/navigation_helper.dart';
import 'package:kioku_navi/widgets/custom_loader.dart';

abstract class BaseController extends GetxController with NavigationHelper {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool hasError = false.obs;

  /// Enhanced safeApiCall with CustomLoader integration
  /// [apiCall] - The API function to execute
  /// [context] - BuildContext for showing loader (optional)
  /// [loaderMessage] - Message to show in loader (optional)
  /// [useLoader] - Whether to show visual loader (default: true if context provided)
  /// [onSuccess] - Callback to execute after successful API call (for navigation)
  /// [onError] - Callback to execute when API call fails (for error handling)
  Future<T?> safeApiCall<T>(
    Future<T> Function() apiCall, {
    BuildContext? context,
    String? loaderMessage,
    bool? useLoader,
    VoidCallback? onSuccess,
    Function(dynamic error)? onError,
  }) async {
    bool loaderShown = false;
    try {
      // Set loading state
      isLoading.value = true;
      error.value = '';
      hasError.value = false;

      // Show visual loader if context is provided and useLoader is not false
      final shouldShowLoader = useLoader ?? (context != null);
      if (shouldShowLoader && context != null) {
        CustomLoader.showLoader(context, loaderMessage);
        loaderShown = true;
      }

      // Execute API call
      final result = await apiCall();

      // Hide loader BEFORE executing success callback (navigation)
      if (loaderShown) {
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

      // Hide loader BEFORE executing error callback
      if (loaderShown) {
        CustomLoader.hideLoader();
        loaderShown = false;
        // Small delay to ensure smooth UX transition
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Execute error callback after loader is hidden
      onError?.call(e);

      return null;
    } finally {
      // Hide loading state
      isLoading.value = false;

      // Hide visual loader if it wasn't already hidden
      if (loaderShown) {
        CustomLoader.hideLoader();
      }
    }
  }

  /// Backward compatible safeApiCall without loader
  Future<T?> safeApiCallSimple<T>(Future<T> Function() apiCall) async {
    return safeApiCall(apiCall, useLoader: false);
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

  @override
  void onClose() {
    clearNavigation();
    super.onClose();
  }
}
