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

class ParentLoginView extends GetView<AuthController> {
  const ParentLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onBackPressed: () => Get.back(),
        centerTitle: true,
        color: Colors.white,
        titleWidget: CustomTitleText(text: "保護者ログイン"),
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Form(
              key: controller.parentLoginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: k2_5Double.hp),
                  Text(
                    'ログインしてください',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k16Double.sp,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k3Double.hp),

                  CustomTextFormField(
                    textController: controller.email,
                    labelText: 'メールアドレスまたはユーザー名',
                    hintText: 'メールアドレスまたはユーザー名を入力',
                    keyboardType: TextInputType.emailAddress,
                    customValidators: [
                      FormBuilderValidators.required(errorText: kRequired),
                      FormBuilderValidators.email(errorText: "Invalid email"),
                    ],
                  ),
                  SizedBox(height: k1_5Double.hp),
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

                  // Login button
                  CustomButton.ghost(
                    text: 'ログイン',
                    onPressed: () {},
                  ),
                  SizedBox(height: k3Double.hp),

                  Center(
                    child: TextButton(
                      onPressed: () {},
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
                  CustomButton.outline(
                    text: 'Google',
                    onPressed: () {},
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
