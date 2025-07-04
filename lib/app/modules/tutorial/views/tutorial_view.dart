// TutorialView created based on Figma design (node 408:348) and user instructions.
// Dolphin icon and bottom button are reused from existing assets/widgets.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

import '../controllers/tutorial_controller.dart';

class TutorialView extends GetView<TutorialController> {
  const TutorialView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.simple(
      message: 'こんにちは！キオだよ！',
      nextRoute: Routes.TUTORIAL_TWO,
    );
  }
}
