import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/widgets/custom_snackbar.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager tokenManager;
  final GetStorage _storage;

  final List<String> publicEndpoints = [
    'auth/login',
    'auth/register',
    'auth/forgot-password',
    'auth/parents',
    'children/join',
    'children/set-pin',
    'children/auth/pin',
    'children/profiles',
    // Family authentication endpoints (registration flow)
    'family/auth/pre-register',
    'family/auth/verify-email',
    'family/auth/complete-profile',
    'family/auth/login',
    // Family child authentication endpoints
    'family/child/join',
    'family/child/set-pin',
    'family/child/profiles',
    'family/child/login',
  ];

  AuthInterceptor({
    required this.tokenManager,
    GetStorage? storage,
  }) : _storage = storage ?? GetStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // Check if request explicitly wants to force child token
    final forceChildToken = options.extra['forceChildToken'] == true;

    // Debug logging for child token selection
    debugPrint('Auth Interceptor - Path: ${options.path}');
    debugPrint('Auth Interceptor - forceChildToken: $forceChildToken');

    if (forceChildToken) {
      // For child-specific requests, only use child session token
      final childSessionToken = _storage.read('child_session_token');
      debugPrint(
          'Auth Interceptor - child token found: ${childSessionToken != null}');
      if (childSessionToken != null && childSessionToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $childSessionToken';
        debugPrint('Auth Interceptor - child token applied');
      } else {
        debugPrint('Auth Interceptor - no child token available');
      }
    } else {
      // Normal token priority: parent first, then child
      final parentToken = await tokenManager.getToken();
      if (parentToken != null && parentToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $parentToken';
      } else {
        // If no parent token, try child session token
        final childSessionToken = _storage.read('child_session_token');
        if (childSessionToken != null && childSessionToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $childSessionToken';
        }
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized errors for protected endpoints
    if (err.response?.statusCode == 401 &&
        !_isPublicEndpoint(err.requestOptions.path)) {
      // Clear both parent and child authentication data
      await tokenManager.clearToken();
      await _storage.remove('child_session_token');
      await _storage.remove('current_child');

      // Navigate to root screen and clear all previous routes
      Get.offAllNamed(Routes.ROOT_SCREEN);

      // Show message to user
      CustomSnackbar.showInfo(
        title: LocaleKeys.common_errors_sessionExpired.tr,
        message: LocaleKeys.common_errors_pleaseLoginAgain.tr,
      );

      // Don't retry - user needs to login again
      return handler.reject(err);
    }

    // For all other errors, just pass them through
    handler.reject(err);
  }

  bool _isPublicEndpoint(String path) {
    return publicEndpoints
        .any((endpoint) => path == endpoint || path.startsWith('$endpoint/'));
  }
}
