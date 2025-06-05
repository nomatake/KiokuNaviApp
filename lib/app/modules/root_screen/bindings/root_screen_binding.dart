import 'package:get/get.dart';

import '../controllers/root_screen_controller.dart';

class RootScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootScreenController>(RootScreenController.new);
  }
}
