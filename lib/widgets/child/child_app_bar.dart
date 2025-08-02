import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/home/controllers/child_home_controller.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/adaptive_sizes.dart';
import 'package:kioku_navi/utils/app_constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/responsive_wrapper.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_button.dart';
import 'package:kioku_navi/widgets/subject_selection_dialog.dart';

class ChildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int fireCount;
  final int gemCount;
  final ChildHomeController? controller;
  final GlobalKey? subjectButtonKey;
  final ScrollController? scrollController;

  const ChildAppBar({
    super.key,
    required this.fireCount,
    required this.gemCount,
    this.controller,
    this.subjectButtonKey,
    this.scrollController,
  });

  @override
  Size get preferredSize {
    final context = Get.context;
    if (context != null) {
      final double extraHeight = AdaptiveSizes.getAppBarExtraHeight(context);
      // Add extra height for green button row without excess padding
      final double greenButtonHeight = controller != null
          ? AdaptiveSizes.getGreenButtonHeight(context)
          : 0.0;
      return Size.fromHeight(kToolbarHeight + extraHeight + greenButtonHeight);
    }
    return const Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AdaptiveSizes.isTablet(context);
    final double topPadding = AdaptiveSizes.getAppBarTopPadding(context);
    final double bottomPadding = AdaptiveSizes.getAppBarBottomPadding(context);

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding,
            bottom: bottomPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top row with fire/gem counts
              Row(
                children: [
                  // Left section: Fire icon+count
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: k4Double.wp),
                        child: IconCountComponent(
                          icon: Assets.images.fireIcon,
                          count: fireCount,
                          color: const Color(0xFFFF9600),
                          isTablet: isTablet,
                        ),
                      ),
                    ),
                  ),
                  // Center section: Gem icon+count
                  Expanded(
                    child: Center(
                      child: IconCountComponent(
                        icon: Assets.images.gemIcon,
                        count: gemCount,
                        color: const Color(0xFF1CB0F6),
                        isTablet: isTablet,
                      ),
                    ),
                  ),
                  // Right section: Empty for balance
                  const Expanded(child: SizedBox()),
                ],
              ),
              // Spacer between fire/gem row and green button
              if (controller != null) SizedBox(height: k1Double.hp),
              // Green button row (moved from ChildHomeView)
              if (controller != null) _buildGreenButtonRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreenButtonRow(BuildContext context) {
    // Get adaptive sizes
    final double buttonWidth = AdaptiveSizes.getGreenButtonWidth(context);
    final double buttonHeight = AdaptiveSizes.getGreenButtonHeight(context);
    final double iconSize = AdaptiveSizes.getGreenButtonIconSize(context);
    final double separatorHeight =
        AdaptiveSizes.getGreenButtonSeparatorHeight(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: k3Double.wp),
      child: Row(
        children: [
          // Left part (dropdown-like) with comprehensive icon
          SizedBox(
            key: subjectButtonKey,
            width: buttonWidth,
            child: CustomButton.primary(
              text: '',
              buttonColor: const Color(0xFF57CC02),
              shadowColor: const Color(0xFF47A302),
              height: buttonHeight,
              contentPadding: EdgeInsets.zero,
              onPressed: () {
                SubjectSelectionDialog.show(
                  context,
                  buttonKey: subjectButtonKey!,
                  onSubjectSelected: (subject) {
                    controller!.onSubjectSelected(subject);
                  },
                );
              },
              icon: Obx(() => Container(
                    height: iconSize,
                    width: iconSize,
                    alignment: Alignment.center,
                    child: _getSubjectIcon(controller!.selectedSubject.value),
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
        // Top line with dynamic course title
        Obx(() => Text(
              controller!.currentVisibleCourse.value,
              style: textStyle,
              textAlign: TextAlign.center,
            )),
        // Bottom line with dynamic chapter title
        Text(
          controller!.currentVisibleChapter.value,
          style: textStyle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
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

class IconCountComponent extends StatelessWidget {
  final AssetGenImage icon;
  final int count;
  final Color color;
  final bool isTablet;

  const IconCountComponent({
    super.key,
    required this.icon,
    required this.count,
    required this.color,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    // Adaptive sizing for tablets
    final double iconSize = AdaptiveSizes.getAppBarIconSize(context);
    final double fontSize = AdaptiveSizes.getAppBarFontSize(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon.image(
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
        ),
        SizedBox(width: k1Double.wp),
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
