import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/generated/locales.g.dart';
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
                  LocaleKeys.pages_forgotPassword_title.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: k16Double.sp,
                    color: Color(0xFF212121),
                  ),
                ),
                SizedBox(height: k3Double.hp),
                CustomTextFormField(
                  textController: controller.email,
                  labelText:
                      LocaleKeys.pages_forgotPassword_form_email_label.tr,
                  hintText:
                      LocaleKeys.pages_forgotPassword_form_email_placeholder.tr,
                  keyboardType: TextInputType.emailAddress,
                  customValidators: [
                    FormBuilderValidators.required(
                        errorText: LocaleKeys.validation_required.tr),
                    FormBuilderValidators.email(
                        errorText: LocaleKeys.validation_invalidEmail.tr),
                  ],
                ),
                SizedBox(height: k2Double.hp),
                Text(
                  LocaleKeys.pages_forgotPassword_instruction.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: k10Double.sp,
                    color: Color(0xFF272E3E),
                  ),
                ),
                SizedBox(height: k2Double.hp),
                CustomButton(
                  disabled: true,
                  text: LocaleKeys.common_buttons_next.tr,
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
