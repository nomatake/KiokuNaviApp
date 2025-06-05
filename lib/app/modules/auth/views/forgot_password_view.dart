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
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onBackPressed: () => Get.back(),
        color: Colors.white,
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: k2_5Double.hp),
                Text(
                  'パスワードをお忘れですか？',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: k16Double.sp,
                    color: Color(0xFF212121),
                  ),
                ),
                SizedBox(height: k3Double.hp),
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
                SizedBox(height: k2Double.hp),
                Text(
                  'メールアドレスを入力して、パスワード再設定のリンクを受け取りましょう。',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: k10Double.sp,
                    color: Color(0xFF272E3E),
                  ),
                ),
                SizedBox(height: k2Double.hp),
                CustomButton(
                  disabled: true,
                  buttonText: '次へ',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
