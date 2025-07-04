import 'package:flutter/material.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/widgets/base_tutorial_view.dart';

class TutorialTwoView extends StatelessWidget {
  const TutorialTwoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseTutorialView.simple(
      message: '最初のレッスンを始める前に、\nn個の簡単な質問に答えてね！',
      nextRoute: Routes.TUTORIAL_THREE,
    );
  }
}
