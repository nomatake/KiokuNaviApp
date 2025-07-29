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

class ChildJoinView extends GetView<FamilyAuthController> {
  const ChildJoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: CustomAppbar(
        onBackPressed: () => Get.back(),
        centerTitle: true,
        color: Colors.white,
        titleWidget: CustomTitleText(
            text: LocaleKeys.pages_familyAuth_childJoin_title.tr),
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Form(
              key: controller.childJoinFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: k3Double.hp),

                  // Welcome Message
                  Text(
                    LocaleKeys.pages_familyAuth_childJoin_welcomeMessage.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: k24Double.sp,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  SizedBox(height: k2Double.hp),

                  // Instructions
                  Text(
                    LocaleKeys.pages_familyAuth_childJoin_instructions.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: k16Double.sp,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: k4Double.hp),

                  // Join Code Field
                  Text(
                    LocaleKeys.pages_familyAuth_childJoin_joinCodeLabel.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k14Double.sp,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k1Double.hp),

                  CustomTextFormField(
                    textController: controller.joinCode,
                    labelText: LocaleKeys
                        .pages_familyAuth_childJoin_joinCodeInputLabel.tr,
                    hintText: LocaleKeys
                        .pages_familyAuth_childJoin_joinCodePlaceholder.tr,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    customValidators: [
                      FormBuilderValidators.required(
                        errorText: LocaleKeys
                            .pages_familyAuth_childJoin_joinCodeRequired.tr,
                      ),
                      FormBuilderValidators.minLength(
                        6,
                        errorText: LocaleKeys
                            .pages_familyAuth_childJoin_joinCodeLength.tr,
                      ),
                      FormBuilderValidators.maxLength(
                        6,
                        errorText: LocaleKeys
                            .pages_familyAuth_childJoin_joinCodeLength.tr,
                      ),
                      FormBuilderValidators.numeric(
                        errorText: LocaleKeys
                            .pages_familyAuth_childJoin_joinCodeNumeric.tr,
                      ),
                    ],
                  ),
                  SizedBox(height: k4Double.hp),

                  // Info Box
                  Container(
                    padding: EdgeInsets.all(k4Double.wp),
                    decoration: BoxDecoration(
                      color: Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Color(0xFF1976D2).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF1976D2),
                          size: k5Double.wp,
                        ),
                        SizedBox(width: k3Double.wp),
                        Expanded(
                          child: Text(
                            LocaleKeys
                                .pages_familyAuth_childJoin_helpMessage.tr,
                            style: TextStyle(
                              fontSize: k12Double.sp,
                              color: Color(0xFF1976D2),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Join Family Button
                  CustomButton.primary(
                    text: LocaleKeys.pages_familyAuth_childJoin_joinButton.tr,
                    onPressed: () => _handleJoinFamily(context),
                  ),
                  SizedBox(height: k2Double.hp),

                  // Back to Welcome Button
                  CustomButton.outline(
                    text: LocaleKeys.pages_familyAuth_childJoin_backButton.tr,
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleJoinFamily(BuildContext context) {
    if (controller.childJoinFormKey.currentState?.validate() ?? false) {
      controller.joinWithCode(context);
    }
  }
}
