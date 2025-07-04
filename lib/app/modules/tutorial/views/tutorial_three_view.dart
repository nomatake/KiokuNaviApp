import 'package:flutter/material.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialThreeView extends StatelessWidget {
  const TutorialThreeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.interactive(
      message: 'あなたの状況を教えてください',
      nextRoute: Routes.TUTORIAL_FOUR,
      progress: 0.142,
      options: [
        TutorialOption(
          text: '保護者',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '児童',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
        TutorialOption(
          text: '教師',
          onPressed: () {
            // TODO: Handle selection
          },
        ),
      ],
    );
  }
}
