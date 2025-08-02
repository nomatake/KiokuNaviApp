import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/child_home_controller.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/custom_loader.dart';
import 'package:kioku_navi/widgets/padded_wrapper.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/child/child_bottom_nav_bar.dart';
import 'package:kioku_navi/widgets/child/child_app_bar.dart';
import 'package:kioku_navi/widgets/course_section_widget.dart';
import 'package:kioku_navi/generated/locales.g.dart';

class ChildHomeView extends GetView<ChildHomeController> {
  ChildHomeView({super.key});

  final GlobalKey _subjectButtonKey = GlobalKey();
  final GlobalKey _sizedBoxKey = GlobalKey(); // Key to track SizedBox position
  
  static bool _isLoaderShowing = false;

  @override
  Widget build(BuildContext context) {
    // Debug logging (can be removed in production)
    // AdaptiveSizes.logDeviceInfo(context);

    // Set the SizedBox key for intersection detection
    controller.setSizedBoxKey(_sizedBoxKey);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChildAppBar(
        fireCount: 2,
        gemCount: 1180,
        controller: controller,
        subjectButtonKey: _subjectButtonKey,
        scrollController: controller.scrollController,
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
                  // Scrollable course sections
                  SizedBox(
                    key: _sizedBoxKey,
                    height: k2Double.hp,
                  ),
                  Expanded(
                    child: _buildMainContent(context),
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
    final sections = <Widget>[];
    for (int i = 0; i < controller.courseSections.length; i++) {
      final section = controller.courseSections[i];
      sections.add(
        CourseSectionWidget(
          title: section.title,
          isAlignedRight: section.isAlignedRight,
          nodes: section.nodes,
          showDolphin: section.showDolphin,
          onNodeTap: (node) => controller.onNodeTapped(node),
          lastNodeKey: controller.getLastNodeKey(i), // Pass key to last node for tracking
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

  Widget _buildMainContent(BuildContext context) {
    return Obx(() {
      // Handle loading state with dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.isLoadingData.value && !_isLoaderShowing) {
          _isLoaderShowing = true;
          CustomLoader.showLoader(
              context, "Fetching course");
        } else if (!controller.isLoadingData.value && _isLoaderShowing) {
          _isLoaderShowing = false;
          CustomLoader.hideLoader();
        }
      });

      // Show loading state
      if (controller.isLoadingData.value) {
        return const SizedBox.shrink();
      }

      // Show error state
      if (controller.loadingError.value.isNotEmpty) {
        return PaddedWrapper(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(k16Double.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE5E5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.exclamationmark_triangle_fill,
                    size: k24Double.sp,
                    color: const Color(0xFFDC2626),
                  ),
                ),
                SizedBox(height: k3Double.hp),
                Text(
                  LocaleKeys.pages_learning_errors_oopsSomethingWentWrong.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Hiragino Sans',
                    fontSize: k18Double.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: k4Double.hp),
                CustomButton.danger(
                  text: LocaleKeys.common_buttons_tryAgain.tr,
                  onPressed: () => controller.reloadData(),
                ),
              ],
            ),
          ),
        );
      }

      // Show empty state
      if (controller.courseSections.isEmpty) {
        return Center(
          child: Text(
            LocaleKeys.pages_learning_errors_noQuestionsAvailable.tr,
            style: TextStyle(
              fontSize: k16Double.sp,
              color: Colors.grey,
            ),
          ),
        );
      }

      // Show main content
      return SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          children: _buildCourseSections(),
        ),
      );
    });
  }

}
