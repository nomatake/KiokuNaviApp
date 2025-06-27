// TutorialView created based on Figma design (node 408:348) and user instructions.
// Dolphin icon and bottom button are reused from existing assets/widgets.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
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
                      height: k100Double.sp,
                      width: k100Double.sp,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              CustomButton.primary(
                text: '次へ',
                onPressed: () => Get.toNamed(Routes.TUTORIAL_TWO),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
