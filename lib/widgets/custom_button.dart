import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

enum ButtonVariant { primary, outline, secondary }

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.buttonText,
    super.key,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    this.disabled = false,
  });

  final String buttonText;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final Widget? icon;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;
  final bool disabled;

  @override
  Widget build(context) {
    late Color btnColor;
    late Color txtColor;
    late Color? brdColor;
    late FontWeight fontWeight;
    late double letterSpacing;
    late List<BoxShadow>? shadows;

    if (disabled) {
      // Ghost styling when disabled - matching Figma design
      btnColor = buttonColor ?? const Color(0xFFE5E5E5);
      txtColor = textColor ?? const Color(0xFFAFAFAF);
      brdColor = null;
      fontWeight = FontWeight.w500;
      letterSpacing = 0;
      shadows = null;
    } else {
      // Normal variant styling
      switch (variant) {
        case ButtonVariant.primary:
          btnColor =
              buttonColor ?? const Color(0xFF1E88E5).withValues(alpha: 0.8);
          txtColor = textColor ?? Colors.white;
          brdColor = null;
          fontWeight = FontWeight.w800;
          letterSpacing = k1Double.sp;
          shadows = [
            const BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
            const BoxShadow(
              color: Color(0xFF1E88E5),
              offset: Offset(0, 5),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ];
          break;
        case ButtonVariant.outline:
          btnColor = buttonColor ?? Colors.transparent;
          txtColor = textColor ?? const Color(0xFF1976D2);
          brdColor = borderColor ?? const Color(0xFF1E88E5);
          fontWeight = FontWeight.w700;
          letterSpacing = 0;
          shadows = [
            const BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
            const BoxShadow(
              color: Color(0xFF1E88E5),
              offset: Offset(0, 3),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ];
          break;
        case ButtonVariant.secondary:
          btnColor = buttonColor ?? Colors.white;
          txtColor = textColor ?? const Color(0xFF424242);
          brdColor = borderColor ?? const Color(0xFFB0BEC5);
          fontWeight = FontWeight.w500;
          letterSpacing = 0;
          shadows = [
            const BoxShadow(
              color: Color(0x14000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
            BoxShadow(
              color: const Color(0xFFB0BEC5),
              offset: const Offset(0, 3),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ];
          break;
      }
    }

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: disabled
          ? Container(
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  const BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(0, 4),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: btnColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        SizedBox(width: k1Double.wp),
                      ],
                      Text(
                        buttonText,
                        style: TextStyle(
                          fontFamily: 'Hiragino Sans',
                          fontWeight: fontWeight,
                          fontSize: k12Double.sp,
                          color: txtColor,
                          letterSpacing: letterSpacing,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: brdColor != null
                    ? Border.all(color: brdColor, width: 2)
                    : null,
                boxShadow: shadows,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  shadowColor: Colors.transparent,
                  foregroundColor: txtColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: onPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      SizedBox(width: k1Double.wp),
                    ],
                    Text(
                      buttonText,
                      style: TextStyle(
                        fontFamily: 'Hiragino Sans',
                        fontWeight: fontWeight,
                        fontSize: k12Double.sp,
                        color: txtColor,
                        letterSpacing: letterSpacing,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
