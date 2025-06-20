import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
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
        titleWidget: CustomTitleText(text: "総合コース"),
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
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: k2Double.hp),
                  children: [
                    SessionCard(
                      title: '5年下　第16回',
                      subtitle: '総合 第16回',
                      progress: 1.0, // 100% complete
                      showTrophy: true,
                      onTap: () {
                        // Handle tap
                      },
                    ),
                    SizedBox(height: k2Double.hp),
                    SessionCard(
                      title: '5年下　第17回',
                      subtitle: '総合 第17回',
                      progress: 0.965, // ~96.5% complete
                      showTrophy: true,
                      onTap: () {
                        // Handle tap
                      },
                    ),
                    SizedBox(height: k2Double.hp),
                    SessionCard(
                      title: '5年下　第18回',
                      subtitle: '総合 第18回',
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
          ],
        ),
      ),
    );
  }
}
