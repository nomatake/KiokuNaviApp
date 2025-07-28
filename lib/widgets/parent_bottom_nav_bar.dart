import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/utils/accessibility_helper.dart';
import 'package:kioku_navi/utils/app_constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/responsive_wrapper.dart';

class ParentBottomNavBar extends StatelessWidget {
  const ParentBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get responsive dimensions
    final screenInfo = context.screenInfo;
    final responsiveHeight =
        ResponsivePatterns.bottomNavHeight.getValue(screenInfo);
    final isTablet = screenInfo.isTablet;

    // Ensure minimum accessibility tap target while keeping it reasonable
    final accessibleHeight = responsiveHeight > 48.0 ? responsiveHeight : 48.0;

    return Container(
      color: Colors.white, // Ensure consistent background color for safe area
      child: SafeArea(
        top: false,
        child: Container(
          height: accessibleHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0x08000000),
                offset: Offset(0, -4),
                blurRadius: isTablet ? 6 : 4,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                label: LocaleKeys.common_navigation_home.tr,
                icon: Icons.home,
                selected: true,
                isTablet: isTablet,
              ),
              _NavBarItem(
                label: LocaleKeys.common_navigation_course.tr,
                icon: Icons.school,
                isTablet: isTablet,
              ),
              _NavBarItem(
                label: 'Reports',
                icon: Icons.analytics,
                isTablet: isTablet,
              ),
              _NavBarItem(
                label: 'Settings',
                icon: Icons.settings,
                isTablet: isTablet,
              ),
              _NavBarItem(
                label: LocaleKeys.common_buttons_logout.tr,
                icon: Icons.logout,
                isTablet: isTablet,
                onTap: () {
                  // Use Get.find to get existing instance or create if needed
                  final AuthController authController;
                  if (Get.isRegistered<AuthController>()) {
                    authController = Get.find<AuthController>();
                  } else {
                    authController = Get.put(AuthController());
                  }
                  authController.logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool isTablet;
  final VoidCallback? onTap;

  const _NavBarItem({
    required this.label,
    required this.icon,
    this.selected = false,
    this.isTablet = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get responsive dimensions based on tablet status
    final iconSize = isTablet ? AppIconSize.md.sp : AppIconSize.xs.sp;
    final fontSize = isTablet ? 12.0.sp : 8.0.sp;
    final spacing = isTablet ? 3.0.wp : 1.5.wp;

    // Colors
    final selectedColor = const Color(0xFF1976D2);
    final unselectedColor = const Color(0xFF7F7F7F);

    // Accessibility
    final semanticsLabel = AccessibilityHelper.getButtonSemanticLabel(
      label,
      hint: selected
          ? LocaleKeys.common_status_selected.tr
          : LocaleKeys.common_navigation_tapToNavigate.tr,
    );

    return Expanded(
      child: GestureDetector(
        onTap: () {
          AccessibilityHelper.provideTapFeedback();
          if (onTap != null) {
            onTap!();
          }
        },
        child: AccessibilityHelper.makeAccessible(
          label: semanticsLabel,
          onTap: null, // We handle tap in GestureDetector
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? AppSpacing.xxxs.wp : 1.0.wp,
              vertical: isTablet ? AppSpacing.xxxs.hp : 1.0.hp,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Icon(
                    icon,
                    color: selected ? selectedColor : unselectedColor,
                    size: iconSize,
                  ),
                ),
                SizedBox(height: spacing),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: selected ? selectedColor : unselectedColor,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                        fontSize: fontSize,
                        height: 1.1,
                        letterSpacing: isTablet ? 0.0 : -0.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
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
