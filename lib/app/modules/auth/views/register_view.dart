import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_date_picker_form_field.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.setupNavigation();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: RegisterAppBar(
        progress: 0.5,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Form(
              key: controller.registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: k2_5Double.hp),

                  // Title
                  Text(
                    '保護者アカウントの作成',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k16Double.sp,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k3Double.hp),

                  // Name field
                  CustomTextFormField(
                    textController: controller.name,
                    labelText: 'お名前',
                    hintText: '氏名を入力',
                    textInputAction: TextInputAction.next,
                    customValidators: [
                      FormBuilderValidators.required(errorText: kRequired),
                    ],
                  ),
                  SizedBox(height: k1_5Double.hp),

                  // Date of Birth field
                  CustomDatePickerFormField(
                    textController: controller.dob,
                    selectedDates: controller.selectedDates,
                    onDateSelected: controller.onDateSelected,
                    labelText: '生年月日',
                    hintText: '例: 2000/01/01',
                    customValidators: [
                      FormBuilderValidators.required(errorText: kRequired),
                      (value) {
                        if (controller.selectedDates.isEmpty ||
                            controller.selectedDates.first == null) {
                          return kRequired;
                        }
                        return null;
                      },
                    ],
                  ),
                  SizedBox(height: k1_5Double.hp),

                  // Email field
                  CustomTextFormField(
                    textController: controller.email,
                    labelText: '保護者の方のメールアドレス',
                    hintText: 'メールアドレスを入力',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
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
                    textInputAction: TextInputAction.next,
                    customValidators: [
                      FormBuilderValidators.required(errorText: kRequired),
                      FormBuilderValidators.minLength(6,
                          errorText: "Password must be at least 6 characters"),
                    ],
                  ),
                  SizedBox(height: k1_5Double.hp),

                  // Password confirmation field
                  CustomTextFormField(
                    textController: controller.passwordConfirmation,
                    labelText: 'パスワード確認',
                    hintText: 'パスワードを再入力',
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    customValidators: [
                      FormBuilderValidators.required(errorText: kRequired),
                      FormBuilderValidators.minLength(6,
                          errorText: "Password must be at least 6 characters"),
                      (value) {
                        if (value != controller.password.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ],
                  ),
                  SizedBox(height: k3Double.hp),

                  // Terms and privacy policy notice
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: k12Double.wp),
                      child: Text(
                        '新規登録をすることにより、キオクナビのサービス利用規約とプライバシーポリシーに同意したものと見なされます',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: k9Double.sp,
                          color: Color(0xFF5A637B),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: k3Double.hp),

                  // Register button
                  CustomButton(
                    text: 'アカウントを作成する',
                    onPressed: () => controller.onRegister(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
