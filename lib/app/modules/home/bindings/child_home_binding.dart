import 'package:get/get.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';

import '../controllers/child_home_controller.dart';
import '../services/child_api.dart';
import '../services/child_api_impl.dart';

class ChildHomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register ChildApi service
    Get.lazyPut<ChildApi>(
      () => ChildApiImpl(
        apiClient: Get.find<BaseApiClient>(),
      ),
    );

    Get.lazyPut<ChildHomeController>(
      () => ChildHomeController(),
    );
  }
}
