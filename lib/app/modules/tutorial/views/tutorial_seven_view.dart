import 'package:flutter/material.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialSevenView extends StatelessWidget {
  const TutorialSevenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.interactive(
      message: '毎日の目標はどれがいい？',
      nextRoute: Routes.TUTORIAL_EIGHT,
      progress: 0.714,
      options: [
        TutorialOption(
          text: '5分 / 日',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '10分 / 日',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '15分 / 日',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '30分 / 日',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
      ],
    );
  }
}
