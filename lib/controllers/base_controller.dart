import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/navigation_helper.dart';

abstract class BaseController extends GetxController with NavigationHelper {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool hasError = false.obs;

  Future<T?> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      isLoading.value = true;
      error.value = '';
      hasError.value = false;
      return await apiCall();
    } catch (e) {
      error.value = e.toString();
      hasError.value = true;
      debugPrint('API Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<T?> safeCall<T>(Future<T> Function() call, {String? errorMessage}) async {
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