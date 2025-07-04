import 'package:flutter/material.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialFiveView extends StatelessWidget {
  const TutorialFiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.interactive(
      message: '通っている塾はどれですか？',
      nextRoute: Routes.TUTORIAL_SIX,
      progress: 0.428,
      options: [
        TutorialOption(
          text: '早稲田アカデミー',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '四谷大塚',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: 'SAPIX',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '日能研',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: 'それ以外',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
      ],
    );
  }
}
