import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';


class RootScreenView extends GetView<AuthController> {
  const RootScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PaddedWrapper(
          bottom: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo
              Center(
                child: Assets.images.logo.image(
                  fit: BoxFit.contain,
                  height: k35Double.wp,
                  width: k35Double.wp,
                ),
              ),
              SizedBox(height: k2Double.hp),

              // Title
              Text(
                'キオクナビ',
                style: TextStyle(
                  fontFamily: 'Hiragino Sans',
                  fontWeight: FontWeight.w800,
                  fontSize: k20Double.sp,
                  color: Color(0xFF1976D2),
                ),
              ),
              SizedBox(height: k1Double.hp),

              // Subtitle
              Text(
                '楽しく学ぼう',
                style: TextStyle(
                  fontFamily: 'Hiragino Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: k12Double.sp,
                  color: Color(0xFFB1B1B1),
                ),
              ),
              const Spacer(),

              // Sign Up Button
              CustomButton(
                buttonText: '新規登録',
                onPressed: () {},
              ),
              SizedBox(height: k2Double.hp),

              // Login as Student
              CustomButton(
                buttonText: '生徒としてログイン',
                variant: ButtonVariant.outline,
                onPressed: () {},
              ),
              SizedBox(height: k2Double.hp),

              // Login as Guardian
              CustomButton(
                buttonText: '保護者としてログイン',
                variant: ButtonVariant.outline,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
