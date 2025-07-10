import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialFiveView extends StatelessWidget {
  const TutorialFiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.interactive(
      message: LocaleKeys.pages_tutorial_five_question.tr,
      nextRoute: Routes.TUTORIAL_SIX,
      progress: 0.428,
      options: [
        TutorialOption(
          text: LocaleKeys.pages_tutorial_five_options_waseda.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_five_options_yotsuya.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_five_options_sapix.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_five_options_nichinoken.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_five_options_other.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
      ],
    );
  }
}
