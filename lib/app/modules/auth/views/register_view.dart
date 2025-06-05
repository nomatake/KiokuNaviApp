import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: RegisterAppBar(
        progress: 0.5,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kRegisterHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kGapAppBarToHeader),
                const Text(
                  '保護者アカウントの作成',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: kGapBetweenInputs),
                CustomTextFormField(
                  textController: controller.emailController,
                  labelText: '保護者の方のメールアドレス',
                  hintText: 'メールアドレスを入力',
                  keyboardType: TextInputType.emailAddress,
                  customValidators: [
                    (value) => value == null || value.isEmpty ? '必須項目です' : null,
                    (value) => value != null && !value.contains('@') ? '有効なメールアドレスを入力してください' : null,
                  ],
                ),
                const SizedBox(height: kGapBetweenInputs),
                CustomTextFormField(
                  textController: controller.birthdayController,
                  labelText: '生年月日',
                  hintText: '例: 2000/01/01',
                  keyboardType: TextInputType.datetime,
                  customValidators: [
                    (value) => value == null || value.isEmpty ? '必須項目です' : null,
                  ],
                ),
                const SizedBox(height: kGapBetweenInputs),
                CustomTextFormField(
                  textController: controller.passwordController,
                  labelText: 'パスワード',
                  hintText: 'パスワードを入力',
                  isPassword: true,
                  customValidators: [
                    (value) => value == null || value.isEmpty ? '必須項目です' : null,
                    (value) => value != null && value.length < 6 ? '6文字以上で入力してください' : null,
                  ],
                ),
                const SizedBox(height: kGapInputToTerms),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: kRegisterTermsHorizontalPadding),
                    child: Text(
                      '新規登録をすることにより、キオクナビのサービス利用規約とプライバシーポリシーに同意したものと見なされます',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xFF5A637B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: kGapTermsToButton),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAFAFAF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: controller.onRegister,
                    child: const Text(
                      'アカウントを作成する',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
