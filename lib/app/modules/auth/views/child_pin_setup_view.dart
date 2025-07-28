import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/family_auth_controller.dart';
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
        centerTitle: true,
        color: Colors.white,
        titleWidget: CustomTitleText(text: 'Create Your PIN'),
        isHasLeading: false, // Prevent going back during setup
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

                  // Welcome Message
                  Center(
                    child: Text(
                      'Great! You\'re in! 🎉',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: k24Double.sp,
                        color: Color(0xFF1976D2),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: k2Double.hp),

                  // Instructions
                  Text(
                    'Now let\'s create a secure PIN that only you know. You\'ll use this PIN to log in every time.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: k16Double.sp,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: k4Double.hp),

                  // PIN Field
                  Text(
                    'Create Your PIN',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k14Double.sp,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k1Double.hp),

                  CustomTextFormField(
                    textController: controller.childPin,
                    labelText: 'Enter 4-6 digit PIN',
                    hintText: '••••',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    isPassword: true,
                    customValidators: [
                      PinValidator.validatePin,
                    ],
                  ),
                  SizedBox(height: k2Double.hp),

                  // Confirm PIN Field
                  Text(
                    'Confirm Your PIN',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k14Double.sp,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k1Double.hp),

                  CustomTextFormField(
                    textController: controller.childPinConfirmation,
                    labelText: 'Re-enter your PIN',
                    hintText: '••••',
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    isPassword: true,
                    customValidators: [
                      (value) => PinValidator.validatePinConfirmation(
                            controller.childPin.text,
                            value,
                          ),
                    ],
                  ),
                  SizedBox(height: k4Double.hp),

                  // Security Tips
                  Container(
                    padding: EdgeInsets.all(k4Double.wp),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Color(0xFF9C27B0).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: Color(0xFF9C27B0),
                              size: k5Double.wp,
                            ),
                            SizedBox(width: k2Double.wp),
                            Text(
                              'PIN Security Tips',
                              style: TextStyle(
                                fontSize: k14Double.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF9C27B0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: k2Double.hp),
                        Text(
                          PinValidator.getValidationHint(),
                          style: TextStyle(
                            fontSize: k12Double.sp,
                            color: Color(0xFF9C27B0),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Create PIN Button
                  CustomButton.primary(
                    text: 'Create PIN & Start Learning',
                    onPressed: () => _handleSetupPin(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSetupPin(BuildContext context) {
    if (controller.childPinSetupFormKey.currentState?.validate() ?? false) {
      controller.setChildPin(context);
    }
  }
}
