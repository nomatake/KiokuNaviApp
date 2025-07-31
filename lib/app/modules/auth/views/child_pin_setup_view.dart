import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/family_auth_controller.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/pin_validator.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';
import 'package:kioku_navi/widgets/custom_title_text.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/custom_appbar.dart';

class ChildPinSetupView extends GetView<FamilyAuthController> {
  const ChildPinSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: CustomAppbar(
        onBackPressed: () => Get.back(),
        centerTitle: true,
        color: Colors.white,
        titleWidget: CustomTitleText(
            text: LocaleKeys.pages_familyAuth_childPinSetup_title.tr),
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Form(
              key: controller.childPinSetupFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: k3Double.hp),

                  // Success Message
                  Text(
                    LocaleKeys.pages_familyAuth_childPinSetup_heading.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: k24Double.sp,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  SizedBox(height: k2Double.hp),

                  // Instructions
                  Text(
                    LocaleKeys.pages_familyAuth_childPinSetup_instructions.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: k16Double.sp,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: k4Double.hp),

                  // PIN Field
                  Text(
                    LocaleKeys.pages_familyAuth_childPinSetup_pinLabel.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k14Double.sp,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k1Double.hp),

                  CustomTextFormField(
                    textController: controller.childPin,
                    labelText: LocaleKeys
                        .pages_familyAuth_childPinSetup_pinPlaceholder.tr,
                    isPassword: true,
                    keyboardType: TextInputType.number,
                    validator: PinValidator.validatePin,
                  ),
                  SizedBox(height: k2Double.hp),

                  // Confirm PIN Field
                  Text(
                    LocaleKeys
                        .pages_familyAuth_childPinSetup_confirmPinLabel.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k14Double.sp,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k1Double.hp),

                  CustomTextFormField(
                    textController: controller.childPinConfirmation,
                    labelText: LocaleKeys
                        .pages_familyAuth_childPinSetup_confirmPinPlaceholder
                        .tr,
                    isPassword: true,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      // First validate as PIN
                      final pinValidation = PinValidator.validatePin(value);
                      if (pinValidation != null) return pinValidation;

                      // Then check if matches
                      if (value != controller.childPin.text) {
                        return LocaleKeys
                            .pages_familyAuth_profileCompletion_passwordMismatch
                            .tr;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: k4Double.hp),

                  // Security Tips
                  Container(
                    padding: EdgeInsets.all(k2Double.hp),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F8FF),
                      borderRadius: BorderRadius.circular(k1Double.hp),
                      border: Border.all(color: Color(0xFFE3F2FD)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: Color(0xFF1976D2),
                              size: k5Double.hp,
                            ),
                            SizedBox(width: k1_5Double.hp),
                            Text(
                              LocaleKeys
                                  .pages_familyAuth_childPinSetup_securityTipsLabel
                                  .tr,
                              style: TextStyle(
                                fontSize: k14Double.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: k1Double.hp),
                        Text(
                          '• Choose a PIN that\'s easy for you to remember\n• Don\'t use obvious numbers like 1234 or your birthday\n• Keep your PIN secret - don\'t share it with anyone!',
                          style: TextStyle(
                            fontSize: k12Double.sp,
                            color: Color(0xFF1976D2),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                  SizedBox(height: k4Double.hp),

                  // Create PIN Button
                  CustomButton.primary(
                    text: LocaleKeys
                        .pages_familyAuth_childPinSetup_createButton.tr,
                    onPressed: () => controller.setChildPin(context),
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
