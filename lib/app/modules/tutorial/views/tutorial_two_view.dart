import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_appbar.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_tooltip.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';

class TutorialTwoView extends StatelessWidget {
  const TutorialTwoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onBackPressed: () => Get.back(),
      ),
      body: SafeArea(
        child: PaddedWrapper(
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTooltip(
                        message: '最初のレッスンを始める前に、\nn個の簡単な質問に答えてね！',
                        child: Assets.images.logo.image(
                          height: k35Double.wp,
                          width: k35Double.wp,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Next button
              CustomButton(
                buttonText: '次へ',
                onPressed: () {
                  // TODO: Implement navigation to next tutorial step
                },
                // Use default color and textColor for consistency
              ),
            ],
          ),
        ),
      ),
    );
  }
}
