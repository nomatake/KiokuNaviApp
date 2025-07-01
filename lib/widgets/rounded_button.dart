import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/adaptive_sizes.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.text,
    super.key,
    this.onPressed,
    this.icon,
    this.size = 70,
    this.backgroundColor,
    this.textColor,
    this.shadowColor,
    this.disabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double size;
  final bool disabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? const Color(0xFFE0E0E0); // Default gray background
    final textClr = textColor ?? const Color(0xFF666666); // Default gray text
    final shadowClr =
        shadowColor ?? const Color(0xFFB7B7B7); // Default gray shadow
    final effectiveDisabled = disabled || onPressed == null;

    // Adaptive shadow offset based on device type and node size
    final double shadowOffset =
        AdaptiveSizes.getRoundedButtonShadowOffset(context, size);

    return SizedBox(
      width: size,
      height: size,
      child: InnerShadow(
        shadows: [
          Shadow(
            color: shadowClr,
            offset: Offset(0, shadowOffset), // Adaptive shadow offset
            blurRadius: 0, // No blur as per Figma
          ),
        ],
        child: Material(
          color: bgColor,
          shape: const CircleBorder(),
          elevation: 0,
          shadowColor: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: effectiveDisabled ? null : onPressed,
            child: Container(
              width: size,
              height: size,
              child: Center(
                child: icon ??
                    Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'Hiragino Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: k12Double.sp,
                        color: textClr,
                        letterSpacing: 0,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
