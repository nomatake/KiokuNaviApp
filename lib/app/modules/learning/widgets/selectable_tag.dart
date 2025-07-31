import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

/// A reusable tag widget for multiple select questions
class SelectableTag extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final List<BoxShadow> shadows;
  final VoidCallback? onTap;
  final bool showText;

  const SelectableTag({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.shadows,
    this.onTap,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: k4_5Double.hp,
          constraints: BoxConstraints(minHeight: k4_5Double.hp),
          padding: EdgeInsets.symmetric(
            horizontal: k1_5Double.wp,
            vertical: k0Double.hp,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(k10Double),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
            boxShadow: shadows,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: k12Double.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                color: showText ? textColor : Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}