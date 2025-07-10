import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';
import 'package:kioku_navi/generated/locales.g.dart';

class TutorialTwoView extends StatelessWidget {
  const TutorialTwoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.simple(
      message: LocaleKeys.pages_tutorial_two_message.tr,
      nextRoute: Routes.TUTORIAL_THREE,
    );
  }
}
