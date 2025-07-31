import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/family_auth_controller.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';
import 'package:kioku_navi/widgets/custom_title_text.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/custom_appbar.dart';

class OtpVerificationView extends GetView<FamilyAuthController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: CustomAppbar(
        onBackPressed: () => Get.back(),
        centerTitle: true,
        color: Colors.white,
        titleWidget: CustomTitleText(
            text: LocaleKeys.pages_familyAuth_otpVerification_title.tr),
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Form(
              key: controller.otpVerificationFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: k3Double.hp),

                  // Icon and heading
                  Center(
                    child: Container(
                      width: k20Double.hp,
                      height: k20Double.hp,
                      decoration: BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(k10Double.hp),
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        size: k10Double.hp,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ),
                  SizedBox(height: k3Double.hp),

                  // Title
                  Center(
                    child: Text(
                      LocaleKeys.pages_familyAuth_otpVerification_heading.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: k24Double.sp,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ),
                  SizedBox(height: k2Double.hp),

                  // Instructions
                  Center(
                    child: Text(
                      LocaleKeys
                          .pages_familyAuth_otpVerification_instructions.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: k16Double.sp,
                        color: Color(0xFF666666),
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: k4Double.hp),

                  // OTP Field
                  Text(
                    LocaleKeys.pages_familyAuth_otpVerification_codeLabel.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k14Double.sp,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k1Double.hp),

                  CustomTextFormField(
                    textController: controller.otp,
                    hintText: LocaleKeys
                        .pages_familyAuth_otpVerification_codePlaceholder.tr,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: LocaleKeys
                              .pages_familyAuth_otpVerification_codeRequired
                              .tr),
                      FormBuilderValidators.numeric(
                          errorText: LocaleKeys
                              .pages_familyAuth_otpVerification_codeNumeric.tr),
                      FormBuilderValidators.minLength(6,
                          errorText: LocaleKeys
                              .pages_familyAuth_otpVerification_codeLength.tr),
                      FormBuilderValidators.maxLength(6,
                          errorText: LocaleKeys
                              .pages_familyAuth_otpVerification_codeLength.tr),
                    ]),
                  ),

                  const Spacer(),

                  // Verify Button
                  CustomButton.primary(
                    text: LocaleKeys
                        .pages_familyAuth_otpVerification_verifyButton.tr,
                    onPressed: () => controller.verifyOtp(context),
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
