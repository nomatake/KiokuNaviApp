import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/accessibility_helper.dart';
import 'package:kioku_navi/utils/app_constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/responsive_wrapper.dart';

class ChildBottomNavBar extends StatelessWidget {
  const ChildBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get responsive dimensions
    final screenInfo = context.screenInfo;
    final responsiveHeight =
        ResponsivePatterns.bottomNavHeight.getValue(screenInfo);
    final isTablet = screenInfo.isTablet;

    // Ensure minimum accessibility tap target while keeping it reasonable
    final accessibleHeight = responsiveHeight > 48.0 ? responsiveHeight : 48.0;

    return SafeArea(
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
              label: 'ホーム',
              icon: Icons.home,
              selected: true,
              isTablet: isTablet,
            ),
            _NavBarItem(
              label: 'トレーニング',
              icon: Icons.fitness_center,
              isTablet: isTablet,
            ),
            _NavBarItem(
              label: 'ランキング',
              icon: Icons.emoji_events,
              isTablet: isTablet,
            ),
            _NavBarItem(
              label: 'コース',
              icon: Icons.school,
              isTablet: isTablet,
            ),
            _NavBarItem(
              label: 'その他',
              icon: Icons.settings,
              isTablet: isTablet,
            ),
          ],
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

  const _NavBarItem({
    required this.label,
    required this.icon,
    this.selected = false,
    this.isTablet = false,
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
      hint: selected ? '選択中' : 'タップして移動',
    );

    return Expanded(
      child: AccessibilityHelper.makeAccessible(
        label: semanticsLabel,
        onTap: () {
          AccessibilityHelper.provideTapFeedback();
          // TODO: Add navigation logic
        },
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
    );
  }
}
