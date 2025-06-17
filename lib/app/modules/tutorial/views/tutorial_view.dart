// TutorialView created based on Figma design (node 408:348) and user instructions.
// Dolphin icon and bottom button are reused from existing assets/widgets.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_appbar.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_tooltip.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';

import '../controllers/tutorial_controller.dart';

class TutorialView extends GetView<TutorialController> {
  const TutorialView({super.key});

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
                  child: CustomTooltip(
                    message: 'こんにちは！キオだよ！',
                    child: Assets.images.logo.image(
                      height: k35Double.wp,
                      width: k35Double.wp,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              // Bottom button (already present as CustomButton, reused as per instruction)
              CustomButton(
                buttonText: '次へ',
                onPressed: () {
                  // TODO: Implement navigation or logic for next tutorial step
                },
                // You can add variant or style if needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}
