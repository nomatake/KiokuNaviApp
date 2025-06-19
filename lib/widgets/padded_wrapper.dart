import "package:flutter/material.dart";
import "package:kioku_navi/utils/extensions.dart";
import "package:kioku_navi/utils/sizes.dart";

class PaddedWrapper extends StatelessWidget {
  const PaddedWrapper({
    required this.child,
    this.top = false,
    this.bottom = false,
    this.left = true,
    this.right = true,
    super.key,
  });

  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top ? k4Double.hp : k0Double,
        bottom: bottom ? k2Double.hp : k0Double,
        left: left ? k6Double.wp : k0Double,
        right: right ? k6Double.wp : k0Double,
      ),
      child: child,
    );
  }
}
