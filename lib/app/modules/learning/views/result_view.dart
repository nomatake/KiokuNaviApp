import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_chiclet_button.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/result_stat_card.dart';

class ResultView extends GetView<LearningController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PaddedWrapper(
          bottom: true,
          child: IntrinsicHeightScrollView(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: k10Double.hp,
                    ),
                  ),

                  // Dolphin logo
                  Assets.images.logo.image(
                    height: k100Double.sp,
                    width: k100Double.sp,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: k2_5Double.hp),

                  // Challenge complete text
                  Text(
                    LocaleKeys.pages_learning_result_title.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Hiragino Sans',
                      fontWeight: FontWeight.w800,
                      fontSize: k24Double.sp,
                      color: const Color(0xFF1976D2),
                    ),
                  ),

                  SizedBox(height: k5Double.hp),

                  // Stats cards row
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: k5Double.wp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: ResultStatCard.orange(
                            value:
                                '${controller.progressTracker.correctAnswers}/${controller.totalQuestions}',
                            label: LocaleKeys.pages_learning_result_totalXP.tr,
                          ),
                        ),
                        SizedBox(width: k3Double.wp),
                        Flexible(
                          child: ResultStatCard.blue(
                            value: controller.formattedTotalTime,
                            label: LocaleKeys.pages_learning_result_time.tr,
                          ),
                        ),
                        SizedBox(width: k3Double.wp),
                        Flexible(
                          child: ResultStatCard.green(
                            value:
                                '${controller.progressTracker.scorePercentage.toStringAsFixed(0)}%',
                            label: LocaleKeys
                                .pages_learning_result_accuracyRate.tr,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SizedBox(
                      height: k10Double.hp,
                    ),
                  ),

                  // Get XP button
                  CustomChicletButton.orange(
                    text: LocaleKeys.common_buttons_receiveXP.tr,
                    onPressed: () {
                      Get.toNamed(Routes.CONTINUOUS_PLAY_RECORD);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
