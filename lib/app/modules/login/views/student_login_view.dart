import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/login/controllers/login_controller.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';
import 'package:kioku_navi/utils/constants.dart';

class StudentLoginView extends GetView<LoginController> {
  const StudentLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isEmailValid = false.obs;
    final isPasswordValid = false.obs;
    final isFormValid = false.obs;

    void checkFormValidity() {
      isFormValid.value = isEmailValid.value && isPasswordValid.value;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          '生徒ログイン',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Color(0xFF212121),
            fontFamily: 'Hiragino Sans',
          ),
        ),
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
                  'ログインしてください',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Color(0xFF212121),
                    fontFamily: 'Hiragino Sans',
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: kGapBetweenInputs),
                CustomTextFormField(
                  textController: emailController,
                  labelText: 'メールアドレスまたはユーザー名',
                  hintText: 'メールアドレスまたはユーザー名を入力',
                  keyboardType: TextInputType.emailAddress,
                  customValidators: [
                    (value) => value == null || value.isEmpty ? '必須項目です' : null,
                  ],
                  isValid: isEmailValid,
                  checkFormValidity: checkFormValidity,
                ),
                const SizedBox(height: kGapBetweenInputs),
                CustomTextFormField(
                  textController: passwordController,
                  labelText: 'パスワード',
                  hintText: 'パスワードを入力',
                  isPassword: true,
                  customValidators: [
                    (value) => value == null || value.isEmpty ? '必須項目です' : null,
                    (value) => value != null && value.length < 6 ? '6文字以上で入力してください' : null,
                  ],
                  isValid: isPasswordValid,
                  checkFormValidity: checkFormValidity,
                ),
                const SizedBox(height: kGapTermsToButton),
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormValid.value ? const Color(0xFFE5E5E5) : const Color(0xFFAFAFAF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isFormValid.value ? () {} : null,
                    child: const Text(
                      'ログイン',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Hiragino Sans',
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: kGapBetweenInputs),
                Align(
                  alignment: Alignment.center,
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
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _SocialLoginButton(
                        label: 'Facebook',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SocialLoginButton(
                        label: 'Google',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SocialLoginButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF424242),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFB0BEC5), width: 2),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF424242),
            letterSpacing: 0.32,
            fontFamily: 'Hiragino Sans',
          ),
        ),
      ),
    );
  }
} 