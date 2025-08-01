import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/child_home_controller.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/adaptive_sizes.dart';
import 'package:kioku_navi/widgets/child/child_bottom_nav_bar.dart';
import 'package:kioku_navi/widgets/child/child_app_bar.dart';
import 'package:kioku_navi/widgets/course_section_widget.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/widgets/subject_selection_dialog.dart';
import 'package:kioku_navi/utils/responsive_wrapper.dart';
import 'package:kioku_navi/utils/app_constants.dart';

class ChildHomeView extends GetView<ChildHomeController> {
  ChildHomeView({super.key});

  final GlobalKey _subjectButtonKey = GlobalKey();
  final GlobalKey _sizedBoxKey = GlobalKey(); // Key to track SizedBox position

  @override
  Widget build(BuildContext context) {
    // Debug logging (can be removed in production)
    // AdaptiveSizes.logDeviceInfo(context);

    // Set the SizedBox key for intersection detection
    controller.setSizedBoxKey(_sizedBoxKey);

    // Get adaptive sizes
    final double buttonWidth = AdaptiveSizes.getGreenButtonWidth(context);
    final double buttonHeight = AdaptiveSizes.getGreenButtonHeight(context);
    final double iconSize = AdaptiveSizes.getGreenButtonIconSize(context);
    final double separatorHeight =
        AdaptiveSizes.getGreenButtonSeparatorHeight(context);

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
                      key: _subjectButtonKey,
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
                            buttonKey: _subjectButtonKey,
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
                        text: '',
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
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Obx(() => _buildLessonText(context)),
                        ),
                      ),
                    ),
                  ]),
                  // Scrollable course sections
                  SizedBox(
                    key: _sizedBoxKey,
                    height: k2Double.hp,
                  ),
                  Expanded(
                    child: Obx(() => SingleChildScrollView(
                          controller: controller.scrollController,
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

  Widget _buildLessonText(BuildContext context) {
    final screenInfo = context.screenInfo;
    final fontSize = ResponsivePatterns.bodyFontSize.getValue(screenInfo).sp;
    
    // Extract common text style to avoid duplication
    final textStyle = TextStyle(
      fontFamily: 'Hiragino Sans',
      fontWeight: FontWeight.w800,
      fontSize: fontSize,
      color: Colors.white,
      letterSpacing: AppSpacing.xxxs.sp,
    );
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Top line with grade and lesson number
        Text(
          '5年下・第18回',
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        // Bottom line with dynamic chapter title
        Text(
          controller.currentVisibleChapter.value,
          style: textStyle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  List<Widget> _buildCourseSections() {
    final sections = <Widget>[];
    for (int i = 0; i < controller.courseSections.length; i++) {
      final section = controller.courseSections[i];
      sections.add(
        CourseSectionWidget(
          title: section.title,
          isAlignedRight: section.isAlignedRight,
          nodes: section.nodes,
          showDolphin: section.showDolphin,
          onTap: () => controller.onSectionTapped(section),
          headerKey: controller.getSectionKey(i), // Pass key to header specifically
        ),
      );
    }

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
