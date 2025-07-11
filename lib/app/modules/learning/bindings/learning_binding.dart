import 'package:get/get.dart';

import '../controllers/learning_controller.dart';
import '../services/course_api.dart';
import '../services/course_service.dart';

class LearningBinding extends Bindings {
  @override
  void dependencies() {
    // Register course service (depends on globally registered CourseApi)
    Get.lazyPut<CourseService>(
      () => CourseService(Get.find<CourseApi>()),
    );

    // Register learning controller
    Get.lazyPut<LearningController>(
      () => LearningController(),
    );
  }
}
