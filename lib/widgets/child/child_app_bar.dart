import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/adaptive_sizes.dart';
import 'package:kioku_navi/generated/assets.gen.dart';

class ChildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int fireCount;
  final int gemCount;

  const ChildAppBar({
    super.key,
    required this.fireCount,
    required this.gemCount,
  });

  @override
  Size get preferredSize {
    final context = Get.context;
    if (context != null) {
      final double extraHeight = AdaptiveSizes.getAppBarExtraHeight(context);
      return Size.fromHeight(kToolbarHeight + extraHeight);
    }
    return const Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = AdaptiveSizes.isTablet(context);
    final double topPadding = AdaptiveSizes.getAppBarTopPadding(context);
    final double bottomPadding = AdaptiveSizes.getAppBarBottomPadding(context);

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding,
            bottom: bottomPadding,
          ),
          child: Center(
            child: Row(
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
          ),
        ),
      ),
    );
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
