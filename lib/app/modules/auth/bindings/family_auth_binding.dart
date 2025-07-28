import 'package:get/get.dart';
import '../controllers/family_auth_controller.dart';

class FamilyAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyAuthController>(() => FamilyAuthController());
  }
}
