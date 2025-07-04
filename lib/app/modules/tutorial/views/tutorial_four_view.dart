import 'package:flutter/material.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialFourView extends StatelessWidget {
  const TutorialFourView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.interactive(
      message: 'お子様の学年を教えてください',
      nextRoute: Routes.TUTORIAL_FIVE,
      progress: 0.285,
      options: [
        TutorialOption(
          text: '小学３年生',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '小学４年生',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '小学５年生',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '小学６年生',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '中学１年生',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '中学２年生',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
      ],
    );
  }
}
