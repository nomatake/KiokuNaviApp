import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/child/child_app_bar.dart';
import 'package:kioku_navi/widgets/child/child_bottom_nav_bar.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';

import '../controllers/child_home_controller.dart';

class ChildHomeView extends GetView<ChildHomeController> {
  const ChildHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ChildAppBar(
        fireCount: 2,
        gemCount: 1180,
      ),
      body: Column(
        children: [
          Expanded(
            child: PaddedWrapper(
              bottom: true,
              child: Column(
                children: [
                  // Split Button Section using CustomButton components
                  Row(
                    children: [
                      // Left part (dropdown-like) with comprehensive icon
                      SizedBox(
                        width: k18Double.wp, // ~68px from Figma
                        child: CustomButton(
                          buttonText: '',
                          buttonColor: const Color(0xFF57CC02),
                          shadowColor: const Color(0xFF47A302),
                          height: k19Double.wp, // 76px from Figma
                          onPressed: () {
                            // TODO: Add dropdown functionality
                          },
                          icon: SizedBox(
                            height: k13Double.wp,
                            width: k13Double.wp,
                            child: Assets.images.comprehensive.image(),
                          ),
                        ),
                      ),
                      // Separator line
                      Container(
                        height: k12Double.wp,
                        width: 1,
                        color: const Color(0xFFF7F9FC),
                      ),
                      // Right part (label) with lesson information
                      Expanded(
                        child: CustomButton(
                          buttonText: '5年下・第18回\n日本のおもな都市・地形図の読み方',
                          buttonColor: const Color(0xFF57CC02),
                          shadowColor: const Color(0xFF47A302),
                          textColor: Colors.white,
                          height: k19Double.wp, // 76px from Figma
                          contentPadding: EdgeInsets.symmetric(
                            horizontal:
                                k2Double.wp, // Reduced horizontal padding
                            vertical: k2Double.wp,
                          ),
                          onPressed: () {
                            // TODO: Add lesson navigation
                          },
                        ),
                      ),
                    ],
                  ),
                  // Additional components will be added here later
                ],
              ),
            ),
          ),
          // Bottom Navigation Bar (custom)
          const ChildBottomNavBar(),
        ],
      ),
    );
  }
}
