import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialSevenView extends StatelessWidget {
  const TutorialSevenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.interactive(
      message: LocaleKeys.pages_tutorial_seven_question.tr,
      nextRoute: Routes.TUTORIAL_EIGHT,
      progress: 0.714,
      options: [
        TutorialOption(
          text: LocaleKeys.pages_tutorial_seven_options_fiveMin.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_seven_options_tenMin.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_seven_options_fifteenMin.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_seven_options_thirtyMin.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
      ],
    );
  }
}
