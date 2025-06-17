import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/child_home_controller.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/widgets/custom_title_text.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/child/child_bottom_nav_bar.dart';
import 'package:kioku_navi/widgets/child/child_app_bar.dart';

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
                  // Top Section: Profile, Progress, Dolphin Logo
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile/Progress Card (left)
                      Expanded(
                        child: Container(
                          height: k20Double.hp,
                          decoration: BoxDecoration(
                            color: const Color(0xFF57CC02),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(k4Double.wp),
                              bottomLeft: Radius.circular(k4Double.wp),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                              const BoxShadow(
                                color: Color(0xFF47A302),
                                offset: Offset(0, -4),
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(k3Double.wp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CustomTitleText(
                                  text: '5年下・第18回',
                                  fontSize: k15Double,
                                  textColor: Color(0xBFFFFFFF),
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 4),
                                CustomTitleText(
                                  text: '日本のおもな都市・地形図の読み方',
                                  fontSize: k17Double,
                                  textColor: Color(0xFF2196F3),
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Progress/Score Card (right)
                      Container(
                        height: k20Double.hp,
                        width: k18Double.wp,
                        decoration: BoxDecoration(
                          color: const Color(0xFF57CC02).withOpacity(0.2),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(k4Double.wp),
                            bottomRight: Radius.circular(k4Double.wp),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                            const BoxShadow(
                              color: Color(0xFF47A302),
                              offset: Offset(0, -4),
                              blurRadius: 0,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CustomTitleText(
                              text: '1180',
                              fontSize: k17Double,
                              textColor: Color(0xFF1CB0F6),
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 4),
                            CustomTitleText(
                              text: '2',
                              fontSize: k17Double,
                              textColor: Color(0xFFFF9600),
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: k4Double.hp),
                  // Dolphin Logo (centered)
                  SizedBox(
                    height: k35Double.wp,
                    width: k35Double.wp,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  SizedBox(height: k4Double.hp),
                  // Start Button
                  CustomButton(
                    buttonText: 'スタート',
                    onPressed: () {},
                  ),
                  const Spacer(),
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
