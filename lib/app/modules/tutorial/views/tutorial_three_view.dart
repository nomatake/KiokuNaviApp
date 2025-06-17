import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

class TutorialThreeView extends StatelessWidget {
  const TutorialThreeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(
        progress: 0.6,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.images.logo.image(
                    height: k35Double.wp,
                    width: k35Double.wp,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: k4Double.wp),
                  Expanded(
                    child: Text(
                      'あなたの状況を教えてください',
                      style: TextStyle(
                        fontFamily: 'Hiragino Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: k18Double.sp,
                        color: const Color(0xFF212121),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: k4Double.hp),
              CustomButton(
                buttonText: '保護者',
                textAlignment: ButtonTextAlignment.centerLeft,
                onPressed: () {
                  // TODO: Handle selection
                },
                variant: ButtonVariant.secondary,
              ),
              SizedBox(height: k2Double.hp),
              CustomButton(
                buttonText: '児童',
                textAlignment: ButtonTextAlignment.centerLeft,
                onPressed: () {
                  // TODO: Handle selection
                },
                variant: ButtonVariant.secondary,
              ),
              SizedBox(height: k2Double.hp),
              CustomButton(
                buttonText: '教師',
                textAlignment: ButtonTextAlignment.centerLeft,
                onPressed: () {
                  // TODO: Handle selection
                },
                variant: ButtonVariant.secondary,
              ),
              const Spacer(),
              CustomButton(
                buttonText: '次へ',
                onPressed: () {
                  // TODO: Handle selection
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
