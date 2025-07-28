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

class ParentPreRegistrationView extends GetView<FamilyAuthController> {
  const ParentPreRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: CustomAppbar(
        onBackPressed: () => Get.back(),
        centerTitle: true,
        color: Colors.white,
        titleWidget: CustomTitleText(text: 'Create Family Account'),
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Form(
              key: controller.parentPreRegistrationFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: k3Double.hp),

                  // Welcome Message
                  Text(
                    'Welcome to KiokuNavi Family!',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: k24Double.sp,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  SizedBox(height: k2Double.hp),

                  // Instructions
                  Text(
                    'Let\'s set up your family account. First, we\'ll verify your email address with a confirmation code.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: k16Double.sp,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: k4Double.hp),

                  // Email Field
                  Text(
                    'Email Address',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k14Double.sp,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k1Double.hp),
                  CustomTextFormField(
                    textController: controller.email,
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Email is required'),
                      FormBuilderValidators.email(
                          errorText: 'Please enter a valid email'),
                    ]),
                  ),
                  SizedBox(height: k1_5Double.hp),

                  // Privacy Notice
                  Container(
                    padding: EdgeInsets.all(k2Double.hp),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F8FF),
                      borderRadius: BorderRadius.circular(k1Double.hp),
                      border: Border.all(color: Color(0xFFE3F2FD)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF1976D2),
                          size: k5Double.hp,
                        ),
                        SizedBox(width: k1_5Double.hp),
                        Expanded(
                          child: Text(
                            'We\'ll send a 6-digit verification code to this email. Make sure you have access to it.',
                            style: TextStyle(
                              fontSize: k12Double.sp,
                              color: Color(0xFF1976D2),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                  SizedBox(height: k4Double.hp),

                  // Continue Button
                  CustomButton.primary(
                    text: 'Send Verification Code',
                    onPressed: () => controller.preRegisterParent(context),
                  ),
                  SizedBox(height: k2Double.hp),

                  // Already have account option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: k12Double.sp,
                          color: Color(0xFF666666),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed('/auth/parent/login'),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: k12Double.sp,
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
