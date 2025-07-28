import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/family_auth_controller.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_text_form_field.dart';
import 'package:kioku_navi/widgets/custom_title_text.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/custom_appbar.dart';
import '../../../../models/user_model.dart';
import '../../../../models/family_model.dart';

class ParentProfileCompletionView extends GetView<FamilyAuthController> {
  const ParentProfileCompletionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: CustomAppbar(
        onBackPressed: () => Get.back(),
        centerTitle: true,
        color: Colors.white,
        titleWidget: CustomTitleText(text: 'Complete Profile'),
      ),
      body: SafeArea(
        child: PaddedWrapper(
          child: Form(
            key: controller.parentProfileCompletionFormKey,
            child: Column(
              children: [
                // Scrollable content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: k3Double.hp),

                        // Welcome Message
                        Text(
                          'Almost Done!',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: k24Double.sp,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                        SizedBox(height: k2Double.hp),

                        // Instructions
                        Text(
                          'Complete your profile to create your family account and start your learning journey.',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: k16Double.sp,
                            color: Color(0xFF666666),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: k4Double.hp),

                        // Full Name Field
                        Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: k14Double.sp,
                            color: Color(0xFF212121),
                          ),
                        ),
                        SizedBox(height: k1Double.hp),
                        CustomTextFormField(
                          textController: controller.parentName,
                          hintText: 'Enter your full name',
                          customValidators: [
                            FormBuilderValidators.required(
                                errorText: 'Full name is required'),
                            FormBuilderValidators.minLength(2,
                                errorText:
                                    'Name must be at least 2 characters'),
                          ],
                        ),

                        SizedBox(height: k2Double.hp),

                        // Relationship Selection Dropdown
                        Text(
                          'Your Relationship',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: k14Double.sp,
                            color: Color(0xFF212121),
                          ),
                        ),
                        SizedBox(height: k1Double.hp),
                        Obx(() => DropdownButtonFormField<RelationshipType>(
                              value: controller.selectedRelationship.value,
                              decoration: InputDecoration(
                                hintText: 'Select your relationship',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(k1Double.hp),
                                  borderSide:
                                      BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(k1Double.hp),
                                  borderSide:
                                      BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(k1Double.hp),
                                  borderSide: BorderSide(
                                      color: Color(0xFF1976D2), width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: k2Double.hp,
                                  vertical: k1_5Double.hp,
                                ),
                              ),
                              items: RelationshipType.values
                                  .map((RelationshipType relationship) {
                                return DropdownMenuItem<RelationshipType>(
                                  value: relationship,
                                  child: Text(
                                    relationship.value[0].toUpperCase() +
                                        relationship.value.substring(1),
                                    style: TextStyle(
                                      fontSize: k14Double.sp,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (RelationshipType? value) {
                                controller.selectedRelationship.value = value;
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select your relationship';
                                }
                                return null;
                              },
                            )),

                        SizedBox(height: k2Double.hp),

                        // Device Mode Selection
                        Text(
                          'Device Usage',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: k14Double.sp,
                            color: Color(0xFF212121),
                          ),
                        ),
                        SizedBox(height: k1Double.hp),
                        Obx(() => Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(k1Double.hp),
                                border: Border.all(color: Color(0xFFE0E0E0)),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: DeviceMode.values.map((mode) {
                                  return RadioListTile<DeviceMode>(
                                    title: Text(
                                      mode.displayName,
                                      style: TextStyle(
                                        fontSize: k14Double.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    subtitle: Text(
                                      mode.description,
                                      style: TextStyle(
                                        fontSize: k12Double.sp,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                    value: mode,
                                    groupValue:
                                        controller.selectedDeviceMode.value,
                                    activeColor: Color(0xFF1976D2),
                                    onChanged: (DeviceMode? value) {
                                      if (value != null) {
                                        controller.selectedDeviceMode.value =
                                            value;
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                            )),

                        SizedBox(height: k2Double.hp),

                        // Password Field
                        Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: k14Double.sp,
                            color: Color(0xFF212121),
                          ),
                        ),
                        SizedBox(height: k1Double.hp),
                        CustomTextFormField(
                          textController: controller.password,
                          hintText: 'Create a secure password',
                          isPassword: true,
                          customValidators: [
                            FormBuilderValidators.required(
                                errorText: 'Password is required'),
                            FormBuilderValidators.minLength(8,
                                errorText:
                                    'Password must be at least 8 characters'),
                          ],
                        ),

                        SizedBox(height: k2Double.hp),

                        // Confirm Password Field
                        Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: k14Double.sp,
                            color: Color(0xFF212121),
                          ),
                        ),
                        SizedBox(height: k1Double.hp),
                        CustomTextFormField(
                          textController: controller.passwordConfirmation,
                          hintText: 'Confirm your password',
                          isPassword: true,
                          customValidators: [
                            FormBuilderValidators.required(
                                errorText: 'Password confirmation is required'),
                            (value) {
                              if (value != controller.password.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ],
                        ),

                        SizedBox(height: k2Double.hp),
                      ],
                    ),
                  ),
                ),

                // Fixed button at bottom
                Padding(
                  padding: EdgeInsets.only(
                    top: k2Double.hp,
                    bottom: k2Double.hp,
                  ),
                  child: CustomButton.primary(
                    text: 'Create Family Account',
                    onPressed: () => controller.completeParentProfile(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
