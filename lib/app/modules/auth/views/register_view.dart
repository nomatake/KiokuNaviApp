import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_date_picker_form_field.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/register_app_bar.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.setupNavigation();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: RegisterAppBar(
        progress: 0.5,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Form(
              key: controller.registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: k2_5Double.hp),

                  // Title
                  Text(
                    LocaleKeys.pages_register_title.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: k16Double.sp,
                      color: Color(0xFF212121),
                    ),
                  ),
                  SizedBox(height: k3Double.hp),

                  // Name field
                  CustomTextFormField(
                    textController: controller.name,
                    labelText: LocaleKeys.pages_register_form_name_label.tr,
                    hintText:
                        LocaleKeys.pages_register_form_name_placeholder.tr,
                    textInputAction: TextInputAction.next,
                    customValidators: [
                      FormBuilderValidators.required(
                          errorText: LocaleKeys.validation_required.tr),
                    ],
                  ),
                  SizedBox(height: k1_5Double.hp),

                  // Date of Birth field
                  CustomDatePickerFormField(
                    textController: controller.dob,
                    selectedDates: controller.selectedDates,
                    onDateSelected: controller.onDateSelected,
                    labelText:
                        LocaleKeys.pages_register_form_birthDate_label.tr,
                    hintText:
                        LocaleKeys.pages_register_form_birthDate_placeholder.tr,
                    customValidators: [
                      FormBuilderValidators.required(
                          errorText: LocaleKeys.validation_required.tr),
                      (value) {
                        if (controller.selectedDates.isEmpty ||
                            controller.selectedDates.first == null) {
                          return LocaleKeys.validation_required.tr;
                        }
                        return null;
                      },
                    ],
                  ),
                  SizedBox(height: k1_5Double.hp),

                  // Email field
                  CustomTextFormField(
                    textController: controller.email,
                    labelText:
                        LocaleKeys.pages_register_form_parentEmail_label.tr,
                    hintText: LocaleKeys
                        .pages_register_form_parentEmail_placeholder.tr,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    customValidators: [
                      FormBuilderValidators.required(
                          errorText: LocaleKeys.validation_required.tr),
                      FormBuilderValidators.email(
                          errorText: LocaleKeys.validation_invalidEmail.tr),
                    ],
                  ),
                  SizedBox(height: k1_5Double.hp),

                  // Password field
                  CustomTextFormField(
                    textController: controller.password,
                    labelText: LocaleKeys.pages_register_form_password_label.tr,
                    hintText:
                        LocaleKeys.pages_register_form_password_placeholder.tr,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    customValidators: [
                      FormBuilderValidators.required(errorText: kRequired),
                      FormBuilderValidators.minLength(6,
                          errorText:
                              LocaleKeys.validation_passwordMinLength.tr),
                    ],
                  ),
                  SizedBox(height: k1_5Double.hp),

                  // Password confirmation field
                  CustomTextFormField(
                    textController: controller.passwordConfirmation,
                    labelText: LocaleKeys
                        .pages_register_form_passwordConfirmation_label.tr,
                    hintText: LocaleKeys
                        .pages_register_form_passwordConfirmation_placeholder
                        .tr,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    customValidators: [
                      FormBuilderValidators.required(
                          errorText: LocaleKeys.validation_required.tr),
                      FormBuilderValidators.minLength(6,
                          errorText:
                              LocaleKeys.validation_passwordMinLength.tr),
                      (value) {
                        if (value != controller.password.text) {
                          return LocaleKeys.validation_passwordsDoNotMatch.tr;
                        }
                        return null;
                      },
                    ],
                  ),
                  SizedBox(height: k3Double.hp),

                  // Terms and privacy policy notice
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: k12Double.wp),
                      child: Text(
                        LocaleKeys.pages_register_termsText.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: k9Double.sp,
                          color: Color(0xFF5A637B),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: k3Double.hp),

                  // Register button
                  CustomButton(
                    text: LocaleKeys.common_buttons_createAccount.tr,
                    onPressed: () => controller.onRegister(context),
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
