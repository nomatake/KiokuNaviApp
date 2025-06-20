import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';

class TutorialSixView extends StatelessWidget {
  const TutorialSixView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterAppBar(
        progress: 0.5,
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
                    height: k35Double.wp,
                    width: k35Double.wp,
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
                      child: CustomTextFormField.primary(
                        hintText: '入力してください',
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CustomButton.primary(
                text: '次へ',
                onPressed: () {
                  // TODO: Handle next action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
