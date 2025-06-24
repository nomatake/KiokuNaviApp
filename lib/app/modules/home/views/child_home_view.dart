import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/child_home_controller.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/child/child_bottom_nav_bar.dart';
import 'package:kioku_navi/widgets/child/child_app_bar.dart';
import 'package:kioku_navi/widgets/course_section_widget.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/widgets/subject_selection_dialog.dart';

class ChildHomeView extends GetView<ChildHomeController> {
  const ChildHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Adaptive sizing based on screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double shortestSide = MediaQuery.of(context).size.shortestSide;

    print(
        'Screen width: $screenWidth, height: $screenHeight, shortest: $shortestSide'); // Debug log

    // Use shortestSide for better tablet detection
    // iPad mini has ~744 logical pixels on shortest side
    final bool isTablet = shortestSide >= 550;
    final bool isLargeTablet = shortestSide >= 768;

    // Adaptive button dimensions
    final double buttonWidth = isLargeTablet
        ? k14Double.wp // Smaller for iPad Pro
        : isTablet
            ? k15Double.wp // Smaller for iPad
            : k18Double.wp; // Original for phones

    final double buttonHeight = isLargeTablet
        ? k15Double.wp // Smaller for iPad Pro
        : isTablet
            ? k16Double.wp // Smaller for iPad
            : k19Double.wp; // Original for phones

    final double iconSize = isLargeTablet
        ? k9Double.wp // Much smaller for iPad Pro
        : isTablet
            ? k10Double.wp // Much smaller for iPad
            : k13Double.wp; // Original for phones

    final double separatorHeight = isTablet
        ? k10Double.wp // Proportional for tablets
        : k12Double.wp; // Original for phones

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
              bottom: false,
              left: true,
              right: true,
              child: Column(
                children: [
                  Row(children: [
                    // Left part (dropdown-like) with comprehensive icon
                    SizedBox(
                      width: buttonWidth,
                      child: CustomButton.primary(
                        text: '',
                        buttonColor: const Color(0xFF57CC02),
                        shadowColor: const Color(0xFF47A302),
                        height: buttonHeight,
                        contentPadding:
                            EdgeInsets.zero, // Ensure no internal padding
                        onPressed: () {
                          SubjectSelectionDialog.show(
                            context,
                            onSubjectSelected: (subject) {
                              controller.onSubjectSelected(subject);
                            },
                          );
                        },
                        icon: Obx(() => Container(
                              height: iconSize,
                              width: iconSize,
                              alignment: Alignment.center,
                              child: _getSubjectIcon(
                                  controller.selectedSubject.value),
                            )),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(12),
                          right: Radius.circular(0),
                        ),
                      ),
                    ),
                    // Separator line
                    Container(
                      height: separatorHeight,
                      width: 1,
                      color: const Color(0xFFF7F9FC),
                    ),
                    // Right part (label) with lesson information
                    Expanded(
                      child: CustomButton.primary(
                        text: '5年下・第18回\n日本のおもな都市・地形図の読み方',
                        buttonColor: const Color(0xFF57CC02),
                        shadowColor: const Color(0xFF47A302),
                        textColor: Colors.white,
                        height: buttonHeight,
                        onPressed: () {
                          // TODO: Add lesson navigation
                        },
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(0),
                          right: Radius.circular(12),
                        ),
                      ),
                    ),
                  ]),
                  // Scrollable course sections
                  SizedBox(height: k2Double.hp),
                  Expanded(
                    child: Obx(() => SingleChildScrollView(
                          child: Column(
                            children: _buildCourseSections(),
                          ),
                        )),
                  ),
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

  List<Widget> _buildCourseSections() {
    final sections = controller.courseSections.map<Widget>((section) {
      return CourseSectionWidget(
        title: section.title,
        isAlignedRight: section.isAlignedRight,
        nodes: section.nodes,
        showDolphin: section.showDolphin,
        onTap: () => controller.onSectionTapped(section),
      );
    }).toList();

    // Add spacing between sections
    final spacedSections = <Widget>[];
    for (int i = 0; i < sections.length; i++) {
      if (i > 0) {
        spacedSections.add(SizedBox(height: k3Double.hp));
      }
      spacedSections.add(sections[i]);
    }

    return spacedSections;
  }

  Widget _getSubjectIcon(Subject subject) {
    switch (subject) {
      case Subject.comprehensive:
        return Assets.images.comprehensive.image(
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        );
      case Subject.socialStudies:
        return Assets.images.japanIcon.image(
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        );
      case Subject.science:
        return Assets.images.scienceIcon.image(
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        );
      case Subject.japanese:
        return Assets.images.languageIcon.image(
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        );
    }
  }
}
