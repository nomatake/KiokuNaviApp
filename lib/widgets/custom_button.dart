import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

enum ButtonTextAlignment { start, centerLeft, center, centerRight, end }

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.buttonText,
    super.key,
    this.onPressed,
    this.icon,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    this.shadowColor,
    this.contentPadding,
    this.height,
    this.disabled = false,
    this.fontWeight,
    this.letterSpacing,
    this.shadows,
    this.borderWidth,
    this.textAlignment = ButtonTextAlignment.center,
  });

  // Factory constructor for orange variant
  factory CustomButton.orange({
    required String buttonText,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    Color? buttonColor,
    Color? textColor,
    Color? shadowColor,
    EdgeInsetsGeometry? contentPadding,
    double? height,
    bool disabled = false,
    ButtonTextAlignment textAlignment = ButtonTextAlignment.center,
  }) {
    return CustomButton(
      buttonText: buttonText,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? const Color(0xFFF57C00),
      textColor: textColor ?? Colors.white,
      shadowColor: shadowColor ?? const Color(0xFFE56A00),
      contentPadding: contentPadding,
      height: height,
      disabled: disabled,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      textAlignment: textAlignment,
      shadows: [
        const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
        BoxShadow(
          color: shadowColor ?? const Color(0xFFE56A00),
          offset: const Offset(0, 4),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Factory constructor for success variant
  factory CustomButton.success({
    required String buttonText,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    Color? buttonColor,
    Color? textColor,
    Color? shadowColor,
    EdgeInsetsGeometry? contentPadding,
    double? height,
    bool disabled = false,
    ButtonTextAlignment textAlignment = ButtonTextAlignment.center,
  }) {
    return CustomButton(
      buttonText: buttonText,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? const Color(0xFF29CC57),
      textColor: textColor ?? Colors.white,
      shadowColor: shadowColor ?? const Color(0xFF15B440),
      contentPadding: contentPadding,
      height: height,
      disabled: disabled,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      textAlignment: textAlignment,
      shadows: [
        const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
        BoxShadow(
          color: shadowColor ?? const Color(0xFF15B440),
          offset: const Offset(0, 4),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Factory constructor for danger variant
  factory CustomButton.danger({
    required String buttonText,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    Color? buttonColor,
    Color? textColor,
    Color? shadowColor,
    EdgeInsetsGeometry? contentPadding,
    double? height,
    bool disabled = false,
    ButtonTextAlignment textAlignment = ButtonTextAlignment.center,
  }) {
    return CustomButton(
      buttonText: buttonText,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? const Color(0xFFE53935),
      textColor: textColor ?? Colors.white,
      shadowColor: shadowColor ?? const Color(0xFFC62828),
      contentPadding: contentPadding,
      height: height,
      disabled: disabled,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      textAlignment: textAlignment,
      shadows: [
        const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
        BoxShadow(
          color: shadowColor ?? const Color(0xFFC62828),
          offset: const Offset(0, 4),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Factory constructor for primary variant
  factory CustomButton.primary({
    required String buttonText,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    Color? buttonColor,
    Color? textColor,
    Color? shadowColor,
    EdgeInsetsGeometry? contentPadding,
    double? height,
    bool disabled = false,
    ButtonTextAlignment textAlignment = ButtonTextAlignment.center,
  }) {
    return CustomButton(
      buttonText: buttonText,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor:
          buttonColor ?? const Color(0xFF1E88E5).withValues(alpha: 0.8),
      textColor: textColor ?? Colors.white,
      shadowColor: shadowColor ?? const Color(0xFF1E88E5),
      contentPadding: contentPadding,
      height: height,
      disabled: disabled,
      fontWeight: FontWeight.w800,
      letterSpacing: k1Double.sp,
      textAlignment: textAlignment,
      shadows: [
        const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
        BoxShadow(
          color: shadowColor ?? const Color(0xFF1E88E5),
          offset: const Offset(0, 5),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Factory constructor for outline variant
  factory CustomButton.outline({
    required String buttonText,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    Color? buttonColor,
    Color? textColor,
    Color? borderColor,
    Color? shadowColor,
    EdgeInsetsGeometry? contentPadding,
    double? height,
    bool disabled = false,
    double? borderWidth,
    ButtonTextAlignment textAlignment = ButtonTextAlignment.center,
  }) {
    return CustomButton(
      buttonText: buttonText,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? Colors.transparent,
      textColor: textColor ?? const Color(0xFF1976D2),
      borderColor: borderColor ?? const Color(0xFF1E88E5),
      shadowColor: shadowColor ?? const Color(0xFF1E88E5),
      contentPadding: contentPadding,
      height: height,
      disabled: disabled,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      borderWidth: borderWidth ?? 2,
      textAlignment: textAlignment,
      shadows: [
        const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
        BoxShadow(
          color: shadowColor ?? const Color(0xFF1E88E5),
          offset: const Offset(0, 3),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Factory constructor for secondary variant
  factory CustomButton.secondary({
    required String buttonText,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    Color? buttonColor,
    Color? textColor,
    Color? borderColor,
    EdgeInsetsGeometry? contentPadding,
    double? height,
    bool disabled = false,
    double? borderWidth,
    ButtonTextAlignment textAlignment = ButtonTextAlignment.center,
  }) {
    return CustomButton(
      buttonText: buttonText,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? Colors.white,
      textColor: textColor ?? const Color(0xFF424242),
      borderColor: borderColor ?? const Color(0xFFB0BEC5),
      contentPadding: contentPadding,
      height: height,
      disabled: disabled,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      borderWidth: borderWidth ?? 2,
      textAlignment: textAlignment,
      shadows: [
        const BoxShadow(
          color: Color(0x14000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
        const BoxShadow(
          color: Color(0xFFB0BEC5),
          offset: Offset(0, 3),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Factory constructor for ghost/disabled variant
  factory CustomButton.ghost({
    required String buttonText,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    Color? buttonColor,
    Color? textColor,
    EdgeInsetsGeometry? contentPadding,
    double? height,
    ButtonTextAlignment textAlignment = ButtonTextAlignment.center,
  }) {
    return CustomButton(
      buttonText: buttonText,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? const Color(0xFFE5E5E5),
      textColor: textColor ?? const Color(0xFFAFAFAF),
      contentPadding: contentPadding,
      height: height,
      disabled: true,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      textAlignment: textAlignment,
      shadows: null,
    );
  }

  final String buttonText;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? buttonColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? shadowColor;
  final EdgeInsetsGeometry? contentPadding;
  final double? height;
  final bool disabled;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final List<BoxShadow>? shadows;
  final double? borderWidth;
  final ButtonTextAlignment textAlignment;

  Alignment getTextAlignment(ButtonTextAlignment alignment) {
    switch (alignment) {
      case ButtonTextAlignment.start:
        return Alignment.centerLeft;
      case ButtonTextAlignment.centerLeft:
        return const Alignment(-0.65, 0); // 25% from left
      case ButtonTextAlignment.center:
        return Alignment.center;
      case ButtonTextAlignment.centerRight:
        return const Alignment(0.65, 0); // 75% from left
      case ButtonTextAlignment.end:
        return Alignment.centerRight;
    }
  }

  Widget buildRow() {
    List<Widget> children = [
      if (icon != null) ...[
        icon!,
        SizedBox(width: k1Double.wp),
      ],
    ];

    EdgeInsets textPadding;
    switch (textAlignment) {
      case ButtonTextAlignment.start:
        textPadding = EdgeInsets.only(left: k4Double.wp);
        break;
      case ButtonTextAlignment.centerLeft:
        textPadding = EdgeInsets.only(left: k4Double.wp);
        break;
      case ButtonTextAlignment.centerRight:
      case ButtonTextAlignment.end:
        textPadding = EdgeInsets.only(right: k4Double.wp);
        break;
      case ButtonTextAlignment.center:
        textPadding = EdgeInsets.zero;
    }

    children.add(
      Expanded(
        child: Align(
          alignment: getTextAlignment(textAlignment),
          child: Padding(
            padding: textPadding,
            child: Text(
              buttonText,
              style: TextStyle(
                fontFamily: 'Hiragino Sans',
                fontWeight: fontWeight ?? FontWeight.w500,
                fontSize: k12Double.sp,
                color: textColor ?? Colors.white,
                letterSpacing: letterSpacing ?? 0,
              ),
            ),
          ),
        ),
      ),
    );

    return Row(children: children);
  }

  @override
  Widget build(context) {
    // Use provided values or defaults
    final btnColor = buttonColor ?? Colors.blue;
    final txtColor = textColor ?? Colors.white;
    final brdColor = borderColor;
    final btnShadows = shadows;

    return SizedBox(
      width: double.infinity,
      height: height ?? 48,
      child: disabled
          ? Container(
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
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
                  child: buildRow(),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: brdColor != null
                    ? Border.all(color: brdColor, width: borderWidth ?? 1)
                    : null,
                boxShadow: btnShadows,
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
                  padding: contentPadding ?? EdgeInsets.zero,
                ),
                onPressed: onPressed,
                child: buildRow(),
              ),
            ),
    );
  }
}
