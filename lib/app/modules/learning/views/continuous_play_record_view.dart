import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_tooltip.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';

class ContinuousPlayRecordView extends GetView<LearningController> {
  const ContinuousPlayRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PaddedWrapper(
          child: IntrinsicHeightScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Landscape padding
                  if (context.isLandscape) SizedBox(height: k5Double.hp),
                  // Tooltip with message
                  CustomTooltip(
                    message: LocaleKeys.pages_learning_continuous_tooltip.tr,
                    backgroundColor: const Color(0xFFFBFCEA),
                    borderColor: const Color(0xFFD8E82F),
                    child: const SizedBox.shrink(),
                  ),

                  // Dolphin logo
                  Assets.images.logo.image(
                    height: k100Double.sp,
                    width: k100Double.sp,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: k2_5Double.hp),

                  // Big number
                  Text(
                    '1',
                    style: TextStyle(
                      fontFamily: 'Hiragino Sans',
                      fontWeight: FontWeight.w800,
                      fontSize: k70Double.sp,
                      color: const Color(0xFFFF9600),
                    ),
                  ),

                  // Days streak text
                  Text(
                    LocaleKeys.pages_learning_continuous_recordText.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Hiragino Sans',
                      fontWeight: FontWeight.w800,
                      fontSize: k24Double.sp,
                      color: const Color(0xFFFF9600),
                    ),
                  ),

                  SizedBox(height: k4Double.hp),

                  // Week days tracker
                  _buildWeekTracker(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeekTracker() {
    final weekDays = [
      LocaleKeys.common_weekdays_mon.tr,
      LocaleKeys.common_weekdays_tue.tr,
      LocaleKeys.common_weekdays_wed.tr,
      LocaleKeys.common_weekdays_thu.tr,
      LocaleKeys.common_weekdays_fri.tr,
      LocaleKeys.common_weekdays_sat.tr,
      LocaleKeys.common_weekdays_sun.tr,
    ];
    final activeDay = 4; // Friday is active (0-indexed)

    return Container(
      padding: EdgeInsets.all(k10Double.sp),
      constraints: BoxConstraints(
        maxWidth: k350Double.sp,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(k15Double),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
          width: k2Double,
        ),
      ),
      child: Column(
        children: [
          // Days of week with circle indicators below
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              weekDays.length,
              (index) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Day text
                  Text(
                    weekDays[index],
                    style: TextStyle(
                      fontFamily: 'Hiragino Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: k14Double.sp,
                      color: index == activeDay
                          ? const Color(0xFFFF9600)
                          : const Color(0xFFAFAFAF),
                    ),
                  ),
                  SizedBox(height: k1Double.hp),
                  // Circle indicator
                  Icon(
                    index == activeDay
                        ? CupertinoIcons.checkmark_alt_circle_fill
                        : CupertinoIcons.circle_fill,
                    color: index == activeDay
                        ? const Color(0xFFFF9600)
                        : const Color(0xFFE5E5E5),
                    size: k30Double.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
