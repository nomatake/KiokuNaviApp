import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

class QuestionView extends GetView<LearningController> {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(
        progress: 0.6,
        onBack: () => Get.back(),
        showCloseIcon: true,
      ),
      body: SafeArea(
        child: PaddedWrapper(
          bottom: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: k1Double.hp),

              // Question title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '正しい意味を選んでください',
                  style: TextStyle(
                    fontFamily: 'Hiragino Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: k15Double.sp,
                    color: const Color(0xFF212121),
                  ),
                ),
              ),
              SizedBox(height: k4Double.hp),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Assets.images.logo.image(
                    height: k20Double.wp,
                    width: k20Double.wp,
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
                        padding: BubbleEdges.all(k10Double),
                        alignment: Alignment.topLeft,
                        nip: BubbleNip.leftBottom,
                        nipWidth: k3Double.wp,
                        nipHeight: k3Double.wp,
                        nipOffset: k15Double,
                        radius: Radius.circular(k14Double),
                      ),
                      child: Text(
                        '考古学に関心がある',
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
              ),
              const Spacer(flex: 3),

              // Answer options
              CustomButton.secondary(
                buttonText: '物事に興味を抱くこと',
                onPressed: () {},
              ),
              SizedBox(height: k2Double.hp),
              CustomButton.secondary(
                buttonText: '心に深く感ずること',
                onPressed: () {},
              ),
              SizedBox(height: k2Double.hp),
              CustomButton.secondary(
                buttonText: '相手に気に入られる心',
                onPressed: () {},
              ),
              const Spacer(),
              // Show Answer button
              CustomButton.orange(
                buttonText: '答えを見る',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
