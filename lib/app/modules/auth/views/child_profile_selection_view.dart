import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/family_auth_controller.dart';
import 'package:kioku_navi/models/child_model.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_title_text.dart';
import 'package:kioku_navi/widgets/intrinsic_height_scroll_view.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/custom_appbar.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';

class ChildProfileSelectionView extends GetView<FamilyAuthController> {
  const ChildProfileSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: CustomAppbar(
        centerTitle: true,
        color: Colors.white,
        titleWidget: CustomTitleText(
            text: LocaleKeys.pages_childProfileSelection_title.tr),
      ),
      body: SafeArea(
        child: IntrinsicHeightScrollView(
          child: PaddedWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: k3Double.hp),

                // Welcome Message
                Center(
                  child: Text(
                    LocaleKeys.pages_childProfileSelection_welcomeMessage.tr,
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
                  LocaleKeys.pages_childProfileSelection_instruction.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: k16Double.sp,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: k4Double.hp),

                // Profile List
                Obx(() {
                  if (controller.availableChildren.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.availableChildren.length,
                    itemBuilder: (context, index) {
                      final child = controller.availableChildren[index];
                      return _buildChildProfile(child);
                    },
                  );
                }),

                SizedBox(height: k4Double.hp),

                // Join New Family Button
                CustomButton.outline(
                  text: LocaleKeys.pages_childProfileSelection_joinNewFamily.tr,
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildProfile(ChildModel child) {
    return Obx(() {
      final isSelected = controller.selectedChild.value?.id == child.id;

      return Container(
        margin: EdgeInsets.only(bottom: k2Double.hp),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectChild(child),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(k4Double.wp),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFE3F2FD) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Color(0xFF1976D2) : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: k12Double.wp,
                    height: k12Double.wp,
                    decoration: BoxDecoration(
                      color: Color(0xFF1976D2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        child.nickname[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: k18Double.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: k4Double.wp),

                  // Child Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.nickname,
                          style: TextStyle(
                            fontSize: k18Double.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        SizedBox(height: k0_5Double.hp),
                        Text(
                          'Age: ${child.age}',
                          style: TextStyle(
                            fontSize: k14Double.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Selection Indicator
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Color(0xFF1976D2),
                      size: k6Double.wp,
                    )
                  else
                    Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey[400],
                      size: k6Double.wp,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: k4Double.hp),
          Icon(
            Icons.child_friendly,
            size: k20Double.wp,
            color: Colors.grey[400],
          ),
          SizedBox(height: k2Double.hp),
          Text(
            LocaleKeys.pages_childProfileSelection_noProfilesFound.tr,
            style: TextStyle(
              fontSize: k18Double.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: k1Double.hp),
          Text(
            LocaleKeys.pages_childProfileSelection_noProfilesMessage.tr,
            style: TextStyle(
              fontSize: k14Double.sp,
              color: Colors.grey[500],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _selectChild(ChildModel child) {
    controller.selectedChild.value = child;

    // Navigate to PIN login after a short delay
    Future.delayed(Duration(milliseconds: 300), () {
      Get.toNamed(Routes.CHILD_PIN_LOGIN);
    });
  }
}
