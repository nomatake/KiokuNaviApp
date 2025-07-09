import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/api/auth_api_impl.dart';
import 'package:kioku_navi/services/api/auth_interceptor.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/services/auth/token_manager_impl.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    // Step 1: API Clients (clean, no interceptors yet)
    Get.lazyPut<BaseApiClient>(() => BaseApiClient(), fenix: true);

    // Step 2: API Services (depend on BaseApiClient)
    Get.lazyPut<AuthApi>(
      () => AuthApiImpl(apiClient: Get.find<BaseApiClient>()),
      fenix: true,
    );

    // Step 3: Auth Services (TokenManager depends on AuthApi for refresh calls)
    Get.lazyPut<TokenManager>(
      () => TokenManagerImpl(authApi: Get.find<AuthApi>()),
      fenix: true,
    );

    // Step 4: Add auth interceptor to API client after all dependencies are ready
    _addAuthInterceptor();
  }

  /// Add AuthInterceptor to BaseApiClient after all dependencies are set up
  void _addAuthInterceptor() {
    // Use a post-frame callback to ensure all dependencies are registered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final apiClient = Get.find<BaseApiClient>();
      final tokenManager = Get.find<TokenManager>();

      // Add auth interceptor
      apiClient.addInterceptor(AuthInterceptor(tokenManager: tokenManager));
    });
  }
}
