import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
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
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Dolphin logo
              Assets.images.logo.image(
                height: k35Double.wp,
                width: k35Double.wp,
                fit: BoxFit.contain,
              ),

              SizedBox(height: k2Double.hp),

              // Challenge complete text
              Text(
                'チャレンジ完了！',
                style: TextStyle(
                  fontFamily: 'Hiragino Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: k24Double.sp,
                  color: const Color(0xFF1976D2),
                ),
              ),

              SizedBox(height: k8Double.hp),

              // Stats cards row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResultStatCard.orange(
                    value: '23',
                    label: '累計XP',
                  ),
                  SizedBox(width: k4Double.wp),
                  ResultStatCard.blue(
                    value: '5:35',
                    label: '時間',
                  ),
                  SizedBox(width: k4Double.wp),
                  ResultStatCard.green(
                    value: '85%',
                    label: '正解率',
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Get XP button
              CustomButton.orange(
                buttonText: 'XPを受け取る',
                onPressed: () {
                  // TODO: Handle get XP action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
