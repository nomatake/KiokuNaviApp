import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
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
                    'チャレンジ完了！',
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
                            value: '23',
                            label: '累計XP',
                          ),
                        ),
                        SizedBox(width: k3Double.wp),
                        Flexible(
                          child: ResultStatCard.blue(
                            value: '5:35',
                            label: '時間',
                          ),
                        ),
                        SizedBox(width: k3Double.wp),
                        Flexible(
                          child: ResultStatCard.green(
                            value: '85%',
                            label: '正解率',
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
                  CustomButton.orange(
                    text: 'XPを受け取る',
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
