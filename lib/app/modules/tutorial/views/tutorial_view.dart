// TutorialView created based on Figma design (node 408:348) and user instructions.
// Dolphin icon and bottom button are reused from existing assets/widgets.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tutorial_controller.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/widgets/custom_tooltip.dart';

class TutorialView extends GetView<TutorialController> {
  const TutorialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: PaddedWrapper(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Back arrow
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFFA6A6A6)),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: 30),
              // CustomTooltip for greeting message (Figma style, always visible)
              CustomTooltip(
                message: 'こんにちは！キオだよ！',
                child: Center(
                  child: Assets.images.logo.image(
                    height: 130,
                    width: 130,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(),
              // Bottom button (already present as CustomButton, reused as per instruction)
              CustomButton(
                buttonText: '次へ',
                onPressed: () {
                  // TODO: Implement navigation or logic for next tutorial step
                },
                // You can add variant or style if needed
              ),
              SizedBox(height: k3Double.hp),
            ],
          ),
        ),
      ),
    );
  }
} 