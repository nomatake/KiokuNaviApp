import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/extensions.dart';
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF7F9FC),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
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
              ),
            ),
          ),
          // Right section: Empty for balance
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class IconCountComponent extends StatelessWidget {
  final AssetGenImage icon;
  final int count;
  final Color color;

  const IconCountComponent({
    super.key,
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon.image(
          width: k6Double.wp,
          height: k6Double.wp,
          fit: BoxFit.contain,
        ),
        SizedBox(width: k1Double.wp),
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: k16Double.sp,
          ),
        ),
      ],
    );
  }
}
