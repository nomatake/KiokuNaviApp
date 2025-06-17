import 'package:flutter/material.dart';
import 'package:kioku_navi/widgets/custom_appbar.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_title_text.dart';

class TutorialTwoView extends StatelessWidget {
  const TutorialTwoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: const CustomAppbar(
        isHasLeading: true,
        titleWidget: null,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        isHasBorder: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          // Dolphin logo
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 130,
              height: 130,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          // Title text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: CustomTitleText(
              text: '最初のレッスンを始める前に、\nn個の簡単な質問に答えてね！',
              textAlign: TextAlign.center,
              fontSize: 18,
              textColor: Color(0xFF4B4B4B),
              fontWeight: FontWeight.w400,
              maxLines: 2,
            ),
          ),
          const Spacer(),
          // Next button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 24.0),
            child: CustomButton(
              buttonText: '次へ',
              onPressed: () {
                // TODO: Implement navigation to next tutorial step
              },
              buttonColor: const Color(0xFF1976D2),
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
} 