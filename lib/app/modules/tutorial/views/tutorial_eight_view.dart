import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialEightView extends StatelessWidget {
  const TutorialEightView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.interactive(
      message: LocaleKeys.pages_tutorial_eight_message.tr,
      nextRoute: Routes.TUTORIAL_NINE,
      progress: 0.857,
      options: [], // No options for this view
    );
  }
}
