import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_tooltip.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';

class ContinuousPlayRecordView extends GetView<LearningController> {
  const ContinuousPlayRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: PaddedWrapper(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tooltip with message
                CustomTooltip(
                  message: '新しい連続記録がスタートしたね！毎日レッスンして記録を更新し続けよう。',
                  backgroundColor: const Color(0xFFFBFCEA),
                  borderColor: const Color(0xFFD8E82F),
                  child: const SizedBox.shrink(),
                ),

                // Dolphin logo
                Assets.images.logo.image(
                  height: k35Double.wp,
                  width: k35Double.wp,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: k4Double.hp),

                // Big number
                Text(
                  '1',
                  style: TextStyle(
                    fontFamily: 'Hiragino Sans',
                    fontWeight: FontWeight.w800,
                    fontSize: k80Double.sp,
                    color: const Color(0xFFFF9600),
                  ),
                ),

                // Days streak text
                Text(
                  '日連続記録',
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
    );
  }

  Widget _buildWeekTracker() {
    final weekDays = ['月', '火', '水', '木', '金', '土', '日'];
    final activeDay = 4; // Friday is active (0-indexed)

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: k2Double.wp,
        vertical: k2Double.hp,
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
                    size: k8Double.wp,
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
