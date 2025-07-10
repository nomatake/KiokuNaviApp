import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kioku_navi/generated/locales.g.dart';

import '../controllers/learning_controller.dart';

class LearningView extends GetView<LearningController> {
  const LearningView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.pages_learning_placeholder.tr),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          LocaleKeys.pages_learning_working.tr,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
