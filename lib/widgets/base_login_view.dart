import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_appbar.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';
import 'package:kioku_navi/widgets/custom_title_text.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';

class BaseLoginView extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final AuthController controller;
  final VoidCallback onPressed; // Specific login method for each view

  const BaseLoginView({
    super.key,
    required this.title,
    required this.formKey,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onBackPressed: () => Get.back(),
        centerTitle: true,
        color: Colors.white,
        titleWidget: CustomTitleText(text: title),
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: k2_5Double.hp),
                  Text(
                    'ログインしてください',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k16Double.sp,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k3Double.hp),

                  // Email field for both student and parent login
                  CustomTextFormField(
                    textController: controller.email,
                    labelText: 'メールアドレス',
                    hintText: 'メールアドレスを入力',
                    keyboardType: TextInputType.emailAddress,
                    customValidators: [
                      FormBuilderValidators.required(errorText: kRequired),
                      FormBuilderValidators.email(errorText: "Invalid email"),
                    ],
                  ),
                  SizedBox(height: k1_5Double.hp),

                  // Password field
                  CustomTextFormField(
                    textController: controller.password,
                    labelText: 'パスワード',
                    hintText: 'パスワードを入力',
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    customValidators: [
                      FormBuilderValidators.required(errorText: kRequired),
                      FormBuilderValidators.minLength(6,
                          errorText: "Password must be at least 6 characters"),
                    ],
                  ),
                  SizedBox(height: k3Double.hp),

                  // Login button with passed onPressed method
                  Obx(() => CustomButton.primary(
                        text: 'ログイン',
                        onPressed:
                            controller.isLoading.value ? null : onPressed,
                      )),
                  SizedBox(height: k3Double.hp),

                  // Forgot password button
                  Center(
                    child: TextButton(
                      onPressed: () => controller.onForgotPassword(),
                      child: const Text(
                        'パスワードを忘れた場合',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF23AEEF),
                          fontFamily: 'Hiragino Sans',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: k3Double.hp),

                  // Google login placeholder (TODO: implement when backend is ready)
                  CustomButton.outline(
                    text: 'Google',
                    onPressed: () {
                      // TODO: Implement Google OAuth when backend is ready
                      Get.snackbar(
                        'Google Login',
                        'Google authentication not yet implemented',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
