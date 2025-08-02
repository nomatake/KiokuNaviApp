import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/app/modules/home/services/child_api.dart';
import 'package:kioku_navi/app/modules/home/services/child_api_impl.dart';
import 'package:kioku_navi/app/modules/learning/services/course_api.dart';
import 'package:kioku_navi/app/modules/learning/services/course_api_impl.dart';
import 'package:kioku_navi/config/config_store.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/api/auth_api_impl.dart';
import 'package:kioku_navi/services/api/auth_interceptor.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/services/auth/token_manager_impl.dart';
import 'package:kioku_navi/services/connectivity/connectivity_manager.dart';
import 'package:kioku_navi/services/connectivity/connectivity_service.dart';
import 'package:kioku_navi/services/connectivity/connectivity_service_impl.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    // Step 0: ConfigStore (foundation service - put immediately, not lazily)
    Get.put<ConfigStore>(ConfigStore(), permanent: true);

    // Step 1: GetStorage (shared instance)
    Get.put<GetStorage>(GetStorage(), permanent: true);

    // Step 2: Connectivity Services
    Get.put<ConnectivityService>(
      ConnectivityServiceImpl(),
      permanent: true,
    );

    Get.put<ConnectivityManager>(
      ConnectivityManager(Get.find<ConnectivityService>()),
      permanent: true,
    );

    // Step 4: Token Manager (no dependencies)
    Get.lazyPut<TokenManager>(() => TokenManagerImpl(), fenix: true);

    // Step 5: Create BaseApiClient and immediately set up auth interceptor
    Get.lazyPut<BaseApiClient>(() {
      final apiClient = BaseApiClient();
      final tokenManager = Get.find<TokenManager>();

      // Add auth interceptor FIRST
      apiClient.addInterceptor(AuthInterceptor(
        tokenManager: tokenManager,
        storage: Get.find<GetStorage>(),
      ));

      // Add log interceptor AFTER auth interceptor so it logs the Authorization header
      if (kDebugMode) {
        apiClient.addInterceptor(LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ));
      }

      return apiClient;
    }, fenix: true);

    // Step 6: API Services (depend on BaseApiClient with interceptor already set up)
    Get.lazyPut<AuthApi>(
      () => AuthApiImpl(
        apiClient: Get.find<BaseApiClient>(),
        tokenManager: Get.find<TokenManager>(),
        storage: Get.find<GetStorage>(),
      ),
      fenix: true,
    );

    // Step 7: Course API Service (learning module)
    Get.lazyPut<CourseApi>(
      () => CourseApiImpl(
        apiClient: Get.find<BaseApiClient>(),
      ),
      fenix: true,
    );

    // Step 8: Child API Service (home module)
    Get.lazyPut<ChildApi>(
      () => ChildApiImpl(
        apiClient: Get.find<BaseApiClient>(),
      ),
      fenix: true,
    );
  }
}
