import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';
import 'package:kioku_navi/generated/locales.g.dart';

class TutorialThreeView extends StatelessWidget {
  const TutorialThreeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.interactive(
      message: LocaleKeys.pages_tutorial_three_question.tr,
      nextRoute: Routes.TUTORIAL_FOUR,
      progress: 0.142,
      options: [
        TutorialOption(
          text: LocaleKeys.pages_tutorial_three_options_parent.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_three_options_child.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: LocaleKeys.pages_tutorial_three_options_teacher.tr,
          onPressed: () {
            // TODO: Handle selection
          },
        ),
      ],
    );
  }
}
