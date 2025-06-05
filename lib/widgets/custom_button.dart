import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

enum ButtonVariant { primary, outline, ghost }

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
  });

  final String buttonText;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final Widget? icon;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(context) {
    late Color btnColor;
    late Color txtColor;
    late Color? brdColor;
    late FontWeight fontWeight;
    late double letterSpacing;
    late List<BoxShadow>? shadows;
    late Border? customBorder;

    switch (variant) {
      case ButtonVariant.primary:
        btnColor =
            buttonColor ?? const Color(0xFF1976D2).withValues(alpha: 0.8);
        txtColor = textColor ?? Colors.white;
        brdColor = null;
        customBorder = null;
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
        customBorder = null;
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
      case ButtonVariant.ghost:
        btnColor = buttonColor ?? const Color(0xFFE5E5E5);
        txtColor = textColor ?? const Color(0xFFAFAFAF);
        brdColor = null;
        // Create inset shadow effect using a bottom border
        customBorder = Border(
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
            width: 4,
          ),
        );
        fontWeight = FontWeight.w500;
        letterSpacing = 0;
        shadows = null; // No box shadows for ghost variant
        break;
    }

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Container(
        decoration: BoxDecoration(
          color: variant == ButtonVariant.ghost ? btnColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: customBorder ??
              (brdColor != null ? Border.all(color: brdColor, width: 2) : null),
          boxShadow: shadows,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                variant == ButtonVariant.ghost ? Colors.transparent : btnColor,
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
