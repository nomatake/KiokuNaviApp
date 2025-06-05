import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';
import 'package:kioku_navi/utils/constants.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final isEmailValid = false.obs;
    final isFormValid = false.obs;

    void checkFormValidity() {
      isFormValid.value = isEmailValid.value;
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
        title: null,
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
                  'パスワードをお忘れですか？',
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
                  labelText: 'メールアドレス',
                  hintText: 'メールアドレスを入力',
                  keyboardType: TextInputType.emailAddress,
                  customValidators: [
                    (value) => value == null || value.isEmpty ? '必須項目です' : null,
                    (value) => value != null && !value.contains('@') ? '有効なメールアドレスを入力してください' : null,
                  ],
                  isValid: isEmailValid,
                  checkFormValidity: checkFormValidity,
                ),
                const SizedBox(height: kGapBetweenInputs),
                const Text(
                  'メールアドレスを入力して、パスワード再設定のリンクを受け取りましょう。',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF272E3E),
                    fontFamily: 'Hiragino Sans',
                  ),
                ),
                const SizedBox(height: kGapTermsToButton),
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormValid.value ? const Color(0xFF1E88E5) : const Color(0xFFAFAFAF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isFormValid.value ? () {} : null,
                    child: const Text(
                      '次へ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Hiragino Sans',
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 