import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

class TutorialFiveView extends StatelessWidget {
  const TutorialFiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(
        progress: 0.428,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: PaddedWrapper(
          bottom: true,
          child: IntrinsicHeightScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: k4Double.hp),
                Row(
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
                          elevation: k10Double,
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
                          '通っている塾はどれですか？',
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
                  text: '早稲田アカデミー',
                  textAlignment: ButtonTextAlignment.start,
                  onPressed: () {
                    // TODO: Handle selection
                  },
                ),
                SizedBox(height: k2Double.hp),
                CustomButton.secondary(
                  text: '四谷大塚',
                  textAlignment: ButtonTextAlignment.start,
                  onPressed: () {
                    // TODO: Handle selection
                  },
                ),
                SizedBox(height: k2Double.hp),
                CustomButton.secondary(
                  text: 'SAPIX',
                  textAlignment: ButtonTextAlignment.start,
                  onPressed: () {
                    // TODO: Handle selection
                  },
                ),
                SizedBox(height: k2Double.hp),
                CustomButton.secondary(
                  text: '日能研',
                  textAlignment: ButtonTextAlignment.start,
                  onPressed: () {
                    // TODO: Handle selection
                  },
                ),
                SizedBox(height: k2Double.hp),
                CustomButton.secondary(
                  text: 'それ以外',
                  textAlignment: ButtonTextAlignment.start,
                  onPressed: () {
                    // TODO: Handle selection
                  },
                ),
                Expanded(
                  child: SizedBox(
                    height: k10Double.hp,
                  ),
                ),
                CustomButton.primary(
                  text: '次へ',
                  onPressed: () => Get.toNamed(Routes.TUTORIAL_SIX),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
