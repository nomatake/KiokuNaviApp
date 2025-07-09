import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialFourView extends StatelessWidget {
  const TutorialFourView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.interactive(
      message: LocaleKeys.pages_tutorial_four_question.tr,
      nextRoute: Routes.TUTORIAL_FIVE,
      progress: 0.285,
      options: [
        TutorialOption(
          text: LocaleKeys.pages_tutorial_four_options_grade3.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_four_options_grade4.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_four_options_grade5.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_four_options_grade6.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_four_options_grade7.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_four_options_grade8.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
      ],
    );
  }
}
