import 'package:get/get.dart';
import 'package:kioku_navi/controllers/base_controller.dart';

class HomeController extends BaseController {
  final count = 0.obs;

  void increment() => count.value++;
}
