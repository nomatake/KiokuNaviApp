import 'package:flutter/material.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialSixView extends StatelessWidget {
  const TutorialSixView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.interactive(
      message: 'お子様のお名前を入力してください',
      nextRoute: Routes.TUTORIAL_SEVEN,
      progress: 0.571,
      options: [], // No options for this view
    );
  }
}
