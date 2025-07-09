import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/answer_option_button.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

class QuestionView extends GetView<LearningController> {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up navigation using helper
    controller.setupNavigation();
    
    return Scaffold(
      appBar: RegisterAppBar(
        progress: 0.6,
        onBack: () => Get.back(),
        showCloseIcon: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PaddedWrapper(
              bottom: true,
              child: IntrinsicHeightScrollView(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: k1Double.hp),
                          _buildQuestionHeader(),
                          SizedBox(height: k5Double.hp),
                          _buildQuestionBubble(),
                          Expanded(
                            child: SizedBox(
                              height: k10Double.hp,
                            ),
                          ),
                          _buildAnswerOptions(),
                          Expanded(
                            child: SizedBox(
                              height: k10Double.hp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
            _buildResultOverlayIfNeeded(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        LocaleKeys.pages_learning_question_header.tr,
        style: TextStyle(
          fontFamily: 'Hiragino Sans',
          fontWeight: FontWeight.w700,
          fontSize: k15Double.sp,
          color: const Color(0xFF212121),
        ),
      ),
    );
  }

  Widget _buildQuestionBubble() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Assets.images.logo.image(
          height: k80Double.sp,
          width: k80Double.sp,
          fit: BoxFit.contain,
        ),
        Expanded(
          child: Bubble(
            style: BubbleStyle(
              margin: BubbleEdges.only(top: k10Double),
              elevation: k8Double,
              color: const Color(0xFFF7F7F7),
              borderColor: const Color(0xFFD8D8D8),
              borderWidth: k2_5Double,
              padding: BubbleEdges.all(k10Double.sp),
              alignment: Alignment.topLeft,
              nip: BubbleNip.leftBottom,
              nipWidth: k10Double.sp,
              nipHeight: k10Double.sp,
              nipOffset: k10Double.sp,
              radius: Radius.circular(k14Double),
            ),
            child: Text(
              LocaleKeys.pages_learning_question_text.tr,
              style: TextStyle(
                fontFamily: 'Hiragino Sans',
                fontWeight: FontWeight.w400,
                fontSize: k14Double.sp,
                color: const Color(0xFF212121),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerOptions() {
    return Obx(() {
      return Column(
        children: List.generate(
          controller.options.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: k2Double.hp),
            child: AnswerOptionButton(
              text: controller.options[index],
              state: _getAnswerState(index),
              onPressed: controller.hasSubmitted.value
                  ? null
                  : () => controller.selectOption(index),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildResultOverlayIfNeeded() {
    return Obx(() {
      if (!controller.hasSubmitted.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          margin: EdgeInsets.only(
            left: k4_5Double.wp,
            right: k4_5Double.wp,
            bottom: k4_5Double.wp,
          ),
          child: _buildResultOverlay(
            isCorrect: controller.isCorrect.value,
          ),
        ),
      );
    });
  }

  Widget _buildResultOverlay({required bool isCorrect}) {
    final config = _getResultConfig(isCorrect);

    final containerHeight = k17Double.hp;

    return Container(
      width: double.infinity,
      height: containerHeight,
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(k15Double),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: k4_5Double.wp,
              vertical: k2Double.hp,
            ),
            child: Row(
              children: [
                Icon(
                  config.iconData,
                  color: config.iconColor,
                  size: k20Double.sp,
                ),
                SizedBox(width: k2Double.wp),
                Text(
                  config.text,
                  style: TextStyle(
                    fontFamily: 'Hiragino Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: k14Double.sp,
                    color: config.textColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: k4_5Double.wp),
            child: config.buttonBuilder(
              config.buttonText,
              config.onButtonPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      if (controller.hasSubmitted.value) {
        return Opacity(
          opacity: 0.0,
          child: CustomButton.primary(
            text: LocaleKeys.common_buttons_viewAnswer.tr,
            onPressed: null,
          ),
        );
      }

      final hasSelected = controller.selectedOptionIndex.value != -1;
      return hasSelected
          ? CustomButton.primary(
              text: LocaleKeys.common_buttons_viewAnswer.tr,
              onPressed: controller.submitAnswer,
            )
          : CustomButton.ghost(
              text: LocaleKeys.common_buttons_viewAnswer.tr,
              onPressed: null,
            );
    });
  }

  AnswerState _getAnswerState(int index) {
    if (!controller.hasSubmitted.value) {
      return controller.selectedOptionIndex.value == index
          ? AnswerState.selected
          : AnswerState.none;
    }

    if (index == controller.correctAnswerIndex) {
      return AnswerState.correct;
    }

    if (index == controller.selectedOptionIndex.value &&
        !controller.isCorrect.value) {
      return AnswerState.incorrect;
    }

    return AnswerState.none;
  }

  _ResultConfig _getResultConfig(bool isCorrect) {
    return isCorrect
        ? _ResultConfig(
            backgroundColor: const Color(0xFFD3F5DD),
            iconData: CupertinoIcons.checkmark_alt_circle_fill,
            iconColor: const Color(0xFF019B2B),
            text: LocaleKeys.common_status_correct.tr,
            textColor: const Color(0xFF019B2B),
            buttonText: LocaleKeys.common_buttons_next.tr,
            buttonBuilder: (text, onPressed) => CustomButton.success(
              text: text,
              onPressed: onPressed,
            ),
            onButtonPressed: controller.nextQuestion,
          )
        : _ResultConfig(
            backgroundColor: const Color(0xFFFEE5E5),
            iconData: CupertinoIcons.xmark_circle_fill,
            iconColor: const Color(0xFFB71C1C),
            text: LocaleKeys.common_status_incorrect.tr,
            textColor: const Color(0xFFB71C1C),
            buttonText: LocaleKeys.common_buttons_tryAgain.tr,
            buttonBuilder: (text, onPressed) => CustomButton.danger(
              text: text,
              onPressed: onPressed,
            ),
            onButtonPressed: controller.resetQuestion,
          );
  }
}

class _ResultConfig {
  final Color backgroundColor;
  final IconData iconData;
  final Color iconColor;
  final String text;
  final Color textColor;
  final String buttonText;
  final Widget Function(String text, VoidCallback onPressed) buttonBuilder;
  final VoidCallback onButtonPressed;

  const _ResultConfig({
    required this.backgroundColor,
    required this.iconData,
    required this.iconColor,
    required this.text,
    required this.textColor,
    required this.buttonText,
    required this.buttonBuilder,
    required this.onButtonPressed,
  });
}
