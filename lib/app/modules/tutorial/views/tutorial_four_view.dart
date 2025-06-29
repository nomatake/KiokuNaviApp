import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

class TutorialFourView extends StatelessWidget {
  const TutorialFourView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(
        progress: 0.285,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: PaddedWrapper(
          bottom: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: k4Double.hp),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Assets.images.logo.image(
                    height: k25Double.wp,
                    width: k25Double.wp,
                    fit: BoxFit.contain,
                  ),
                  Expanded(
                    child: Bubble(
                      style: BubbleStyle(
                        margin: BubbleEdges.only(top: k10Double),
                        elevation: k10Double,
                        color: const Color(0xFFF7F7F7),
                        borderColor: const Color(0xFFD8D8D8),
                        borderWidth: k2_5Double,
                        padding: BubbleEdges.all(k10Double),
                        alignment: Alignment.topLeft,
                        nip: BubbleNip.leftBottom,
                        nipWidth: k4Double.wp,
                        nipHeight: k5Double.wp,
                        nipOffset: k25Double,
                        radius: Radius.circular(k14Double),
                      ),
                      child: Text(
                        'お子様の学年を教えてください',
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
              SizedBox(height: k4Double.hp),
              CustomButton.secondary(
                text: '小学３年生',
                textAlignment: ButtonTextAlignment.start,
                onPressed: () {
                  // TODO: Handle selection
                },
              ),
              SizedBox(height: k2Double.hp),
              CustomButton.secondary(
                text: '小学４年生',
                textAlignment: ButtonTextAlignment.start,
                onPressed: () {
                  // TODO: Handle selection
                },
              ),
              SizedBox(height: k2Double.hp),
              CustomButton.secondary(
                text: '小学５年生',
                textAlignment: ButtonTextAlignment.start,
                onPressed: () {
                  // TODO: Handle selection
                },
              ),
              SizedBox(height: k2Double.hp),
              CustomButton.secondary(
                text: '小学６年生',
                textAlignment: ButtonTextAlignment.start,
                onPressed: () {
                  // TODO: Handle selection
                },
              ),
              SizedBox(height: k2Double.hp),
              CustomButton.secondary(
                text: '中学１年生',
                textAlignment: ButtonTextAlignment.start,
                onPressed: () {
                  // TODO: Handle selection
                },
              ),
              SizedBox(height: k2Double.hp),
              CustomButton.secondary(
                text: '中学２年生',
                textAlignment: ButtonTextAlignment.start,
                onPressed: () {
                  // TODO: Handle selection
                },
              ),
              const Spacer(),
              CustomButton.primary(
                text: '次へ',
                onPressed: () => Get.toNamed(Routes.TUTORIAL_FIVE),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
