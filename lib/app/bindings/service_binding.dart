import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/config/config_store.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/api/auth_api_impl.dart';
import 'package:kioku_navi/services/api/auth_interceptor.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/services/auth/token_manager_impl.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    // Step 0: ConfigStore (foundation service - put immediately, not lazily)
    Get.put<ConfigStore>(ConfigStore(), permanent: true);

    // Step 1: GetStorage (shared instance)
    Get.put<GetStorage>(GetStorage(), permanent: true);

    // Step 2: Token Manager (no dependencies)
    Get.lazyPut<TokenManager>(() => TokenManagerImpl(), fenix: true);

    // Step 3: Create BaseApiClient and immediately set up auth interceptor
    Get.lazyPut<BaseApiClient>(() {
      final apiClient = BaseApiClient();
      final tokenManager = Get.find<TokenManager>();

      // Add auth interceptor immediately to avoid race conditions
      apiClient.addInterceptor(AuthInterceptor(tokenManager: tokenManager));

      return apiClient;
    }, fenix: true);

    // Step 4: API Services (depend on BaseApiClient with interceptor already set up)
    Get.lazyPut<AuthApi>(
      () => AuthApiImpl(
        apiClient: Get.find<BaseApiClient>(),
        tokenManager: Get.find<TokenManager>(),
        storage: Get.find<GetStorage>(),
      ),
      fenix: true,
    );
  }
}
