import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_appbar.dart';
import 'package:kioku_navi/widgets/custom_title_text.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/session_card.dart';

class SessionChangeView extends GetView<LearningController> {
  const SessionChangeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        titleWidget: CustomTitleText(text: LocaleKeys.pages_learning_session_comprehensiveCourse.tr),
        centerTitle: true,
        onBackPressed: () => Get.back(),
        isHasBorder: true,
        showCloseIcon: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Session cards list
            Expanded(
              child: PaddedWrapper(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: k350Double.sp, // Maximum width for iPad layouts
                    ),
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: k2Double.hp),
                      children: [
                        SessionCard(
                          title: LocaleKeys.pages_learning_session_grade5Lower16.tr,
                          subtitle: LocaleKeys.pages_learning_session_comprehensive16.tr,
                          progress: 1.0, // 100% complete
                          showTrophy: true,
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        SizedBox(height: k2Double.hp),
                        SessionCard(
                          title: LocaleKeys.pages_learning_session_grade5Lower17.tr,
                          subtitle: LocaleKeys.pages_learning_session_comprehensive17.tr,
                          progress: 0.965, // ~96.5% complete
                          showTrophy: true,
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        SizedBox(height: k2Double.hp),
                        SessionCard(
                          title: LocaleKeys.pages_learning_session_grade5Lower18.tr,
                          subtitle: LocaleKeys.pages_learning_session_comprehensive18.tr,
                          progress: 0.486, // ~48.6% complete
                          showTrophy: true,
                          onTap: () {
                            // Handle tap
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
