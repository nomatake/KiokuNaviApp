import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/result_config.dart';
import 'package:kioku_navi/app/modules/learning/widgets/question_template.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

class QuestionView extends GetView<LearningController> {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: controller.shouldShowAppBar
              ? RegisterAppBar(
                  progress: controller.progressPercentage,
                  onBack: () => Get.back(),
                  showCloseIcon: true,
                )
              : null,
          body: SafeArea(
            bottom: false,
            child: _buildBody(),
          ),
        ));
  }

  Widget _buildBody() {
    return Obx(() {
      // Show loading state
      if (controller.isLoadingTopic.value) {
        return Center(
          child: GFLoader(
            type: Platform.isAndroid ? GFLoaderType.android : GFLoaderType.ios,
            size: GFSize.LARGE,
          ),
        );
      }

      // Show error state
      if (controller.loadingError.value.isNotEmpty) {
        return PaddedWrapper(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(k16Double.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE5E5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.exclamationmark_triangle_fill,
                    size: k24Double.sp,
                    color: const Color(0xFFDC2626),
                  ),
                ),
                SizedBox(height: k3Double.hp),
                Text(
                  LocaleKeys.pages_learning_errors_oopsSomethingWentWrong.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Hiragino Sans',
                    fontSize: k18Double.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: k4Double.hp),
                CustomButton.danger(
                  text: LocaleKeys.common_buttons_tryAgain.tr,
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        );
      }

      // Show empty state
      if (controller.questions.isEmpty) {
        return Center(
          child: Text(
            LocaleKeys.pages_learning_errors_noQuestionsAvailable.tr,
            style: TextStyle(
              fontSize: k16Double.sp,
              color: Colors.grey,
            ),
          ),
        );
      }

      return Column(
        children: [
          Expanded(
            child: PaddedWrapper(
              bottom: false,
              child: IntrinsicHeightScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: k1Double.hp),
                    _buildQuestionHeader(),
                    SizedBox(height: k5Double.hp),
                    _buildQuestionBubble(),
                    SizedBox(height: k5Double.hp),
                    const QuestionTemplate(),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomArea(),
        ],
      );
    });
  }

  Widget _buildQuestionHeader() {
    return Obx(() => Text(
          controller.topic.value?.description ?? '',
          style: TextStyle(
            fontFamily: 'Hiragino Sans',
            fontWeight: FontWeight.w600,
            fontSize: k15Double.sp,
            color: const Color(0xFF212121),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ));
  }

  Widget _buildQuestionBubble() {
    return Obx(() => Row(
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
                  controller.currentQuestionText,
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
        ));
  }

  Widget _buildBottomArea() {
    return Obx(() {
      final hasSubmitted = controller.hasSubmitted.value;
      final hasSelected = controller.selectedOptionIndex.value != -1;

      // Get result configuration if submitted
      final config =
          hasSubmitted ? _getResultConfig(controller.isCorrect.value) : null;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: hasSubmitted ? config!.backgroundColor : Colors.transparent,
          borderRadius: hasSubmitted
              ? BorderRadius.only(
                  topLeft: Radius.circular(k15Double),
                  topRight: Radius.circular(k15Double),
                )
              : null,
        ),
        child: Column(
          children: [
            // Result feedback row (only show when submitted)
            if (hasSubmitted)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: k6Double.wp,
                  vertical: k2Double.hp,
                ),
                child: Row(
                  children: [
                    Icon(
                      config!.iconData,
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
            // Button area
            Padding(
              padding: EdgeInsets.only(
                bottom: k4_5Double.hp,
                left: hasSubmitted ? 0 : k6Double.wp,
                right: hasSubmitted ? 0 : k6Double.wp,
              ),
              child: hasSubmitted
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: k6Double.wp),
                      child: config!.buttonBuilder(
                        config.buttonText,
                        config.onButtonPressed,
                      ),
                    )
                  : hasSelected
                      ? CustomButton.primary(
                          text: LocaleKeys.common_buttons_viewAnswer.tr,
                          onPressed: controller.submitAnswer,
                        )
                      : CustomButton.ghost(
                          text: LocaleKeys.common_buttons_viewAnswer.tr,
                          onPressed: null,
                        ),
            ),
          ],
        ),
      );
    });
  }

  ResultConfig _getResultConfig(bool isCorrect) {
    return ResultConfig(
      backgroundColor:
          isCorrect ? const Color(0xFFD3F5DD) : const Color(0xFFFEE5E5),
      iconData: isCorrect
          ? CupertinoIcons.checkmark_alt_circle_fill
          : CupertinoIcons.xmark_circle_fill,
      iconColor: isCorrect ? const Color(0xFF019B2B) : const Color(0xFFB71C1C),
      text: isCorrect
          ? LocaleKeys.common_status_correct.tr
          : LocaleKeys.common_status_incorrect.tr,
      textColor: isCorrect ? const Color(0xFF019B2B) : const Color(0xFFB71C1C),
      buttonText: controller.hasMoreQuestions
          ? LocaleKeys.common_buttons_next.tr
          : LocaleKeys
              .common_buttons_next.tr, // Use next for now, can be updated later
      buttonBuilder: (text, onPressed) => isCorrect
          ? CustomButton.success(text: text, onPressed: onPressed)
          : CustomButton.danger(text: text, onPressed: onPressed),
      onButtonPressed: controller.nextQuestion,
    );
  }
}
