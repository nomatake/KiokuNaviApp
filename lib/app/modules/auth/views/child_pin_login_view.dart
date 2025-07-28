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

class ChildPinLoginView extends GetView<FamilyAuthController> {
  const ChildPinLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: CustomAppbar(
        centerTitle: true,
        color: Colors.white,
        titleWidget: CustomTitleText(text: 'Enter Your PIN'),
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Form(
              key: controller.childPinLoginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: k3Double.hp),

                  // Child Profile
                  Obx(() {
                    final child = controller.selectedChild.value;
                    if (child == null) {
                      return SizedBox.shrink();
                    }

                    return Center(
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            width: k20Double.wp,
                            height: k20Double.wp,
                            decoration: BoxDecoration(
                              color: Color(0xFF1976D2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                child.nickname[0].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: k24Double.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: k2Double.hp),

                          // Welcome Message
                          Text(
                            'Welcome back, ${child.nickname}!',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: k24Double.sp,
                              color: Color(0xFF1976D2),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: k3Double.hp),

                  // Instructions
                  Text(
                    'Enter your PIN to continue learning.',
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
                  Center(
                    child: Container(
                      width: k60Double.wp,
                      child: CustomTextFormField(
                        textController: controller.childPin,
                        labelText: 'Enter your PIN',
                        hintText: '••••',
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        isPassword: true,
                        customValidators: [
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your PIN';
                            }
                            if (value.length < 4) {
                              return 'PIN must be at least 4 digits';
                            }
                            return null;
                          },
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: k4Double.hp),

                  // Login Button
                  CustomButton.primary(
                    text: 'Start Learning',
                    onPressed: () => _handlePinLogin(context),
                  ),
                  SizedBox(height: k2Double.hp),

                  // Switch Profile Button (for shared devices)
                  CustomButton.outline(
                    text: 'Switch Profile',
                    onPressed: () => Get.back(),
                  ),
                  SizedBox(height: k4Double.hp),

                  // Security Notice
                  Container(
                    padding: EdgeInsets.all(k4Double.wp),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Color(0xFFFF9800).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Color(0xFFFF9800),
                          size: k5Double.wp,
                        ),
                        SizedBox(width: k3Double.wp),
                        Expanded(
                          child: Text(
                            'Your PIN keeps your learning progress safe. Never share it with anyone!',
                            style: TextStyle(
                              fontSize: k12Double.sp,
                              color: Color(0xFFFF9800),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Help Section
                  SizedBox(height: k4Double.hp),
                  Center(
                    child: TextButton(
                      onPressed: () => _showPinHelp(context),
                      child: Text(
                        'Forgot your PIN? Ask your parent for help',
                        style: TextStyle(
                          fontSize: k12Double.sp,
                          color: Color(0xFF1976D2),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePinLogin(BuildContext context) {
    if (controller.childPinLoginFormKey.currentState?.validate() ?? false) {
      final child = controller.selectedChild.value;
      if (child != null) {
        controller.authenticateChildWithPin(context, child);
      }
    }
  }

  void _showPinHelp(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'PIN Help',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If you forgot your PIN:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: k1Double.hp),
            Text('• Ask your parent to help you reset it'),
            SizedBox(height: k0_5Double.hp),
            Text('• They can create a new join code for you'),
            SizedBox(height: k0_5Double.hp),
            Text('• Then you can set up a new PIN'),
            SizedBox(height: k2Double.hp),
            Text(
              'Remember: Your PIN should be something only you know!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Got it!',
              style: TextStyle(color: Color(0xFF1976D2)),
            ),
          ),
        ],
      ),
    );
  }
}
