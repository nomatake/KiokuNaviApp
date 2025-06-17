import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

enum ButtonVariant { primary, outline, secondary, ghost }

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    super.key,
    this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.alignment = MainAxisAlignment.center,
    this.height,
    this.borderRadius,
    this.disabled = false,
    // Override colors
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.shadowColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final ButtonVariant variant;
  final MainAxisAlignment alignment;
  final double? height;
  final BorderRadius? borderRadius;
  final bool disabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? shadowColor;

  // Get variant-specific styling
  ({Color bg, Color text, Color? border, Color shadow, double borderWidth, FontWeight weight}) get _style {
    return switch (variant) {
      ButtonVariant.primary => (
        bg: backgroundColor ?? const Color(0xFF1E88E5).withValues(alpha: 0.8),
        text: textColor ?? Colors.white,
        border: borderColor,
        shadow: shadowColor ?? const Color(0xFF1E88E5),
        borderWidth: 0.0,
        weight: FontWeight.w800,
      ),
      ButtonVariant.outline => (
        bg: backgroundColor ?? Colors.transparent,
        text: textColor ?? const Color(0xFF1976D2),
        border: borderColor ?? const Color(0xFF1E88E5),
        shadow: shadowColor ?? const Color(0xFF1E88E5),
        borderWidth: 2.0,
        weight: FontWeight.w800,
      ),
      ButtonVariant.secondary => (
        bg: backgroundColor ?? Colors.white,
        text: textColor ?? const Color(0xFF424242),
        border: borderColor ?? const Color(0xFFB0BEC5),
        shadow: shadowColor ?? const Color(0xFFB0BEC5),
        borderWidth: 2.0,
        weight: FontWeight.w800,
      ),
      ButtonVariant.ghost => (
        bg: backgroundColor ?? const Color(0xFFE5E5E5),
        text: textColor ?? const Color(0xFFAFAFAF),
        border: borderColor,
        shadow: shadowColor ?? Colors.transparent,
        borderWidth: 0.0,
        weight: FontWeight.w500,
      ),
    };
  }

  List<BoxShadow> get _shadows {
    if (disabled || variant == ButtonVariant.ghost) return [];
    
    final style = _style;
    return [
      const BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: style.shadow,
        offset: Offset(0, variant == ButtonVariant.outline ? 3 : 5),
        blurRadius: 0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    final effectiveDisabled = disabled || variant == ButtonVariant.ghost || onPressed == null;
    final radius = borderRadius ?? BorderRadius.circular(12);

    return SizedBox(
      width: double.infinity,
      height: height ?? 48,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: _shadows,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: style.bg,
            foregroundColor: style.text,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: radius),
            side: style.border != null 
                ? BorderSide(color: style.border!, width: style.borderWidth)
                : null,
            padding: EdgeInsets.zero,
          ),
          onPressed: effectiveDisabled ? null : onPressed,
          child: Row(
            mainAxisAlignment: alignment,
            mainAxisSize: alignment == MainAxisAlignment.center ? MainAxisSize.min : MainAxisSize.max,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: k1Double.wp),
              ],
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Hiragino Sans',
                  fontWeight: style.weight,
                  fontSize: k12Double.sp,
                  letterSpacing: variant == ButtonVariant.primary ? k1Double.sp : 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Factory constructors for convenience
  static CustomButton primary({
    required String text,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    double? height,
    BorderRadius? borderRadius,
    bool disabled = false,
    Color? backgroundColor,
    Color? textColor,
    Color? shadowColor,
  }) => CustomButton(
    text: text, 
    key: key, 
    onPressed: onPressed, 
    icon: icon,
    variant: ButtonVariant.primary,
    alignment: alignment,
    height: height,
    borderRadius: borderRadius,
    disabled: disabled,
    backgroundColor: backgroundColor,
    textColor: textColor,
    shadowColor: shadowColor,
  );

  static CustomButton outline({
    required String text,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    double? height,
    BorderRadius? borderRadius,
    bool disabled = false,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    Color? shadowColor,
  }) => CustomButton(
    text: text,
    key: key,
    onPressed: onPressed,
    icon: icon,
    variant: ButtonVariant.outline,
    alignment: alignment,
    height: height,
    borderRadius: borderRadius,
    disabled: disabled,
    backgroundColor: backgroundColor,
    textColor: textColor,
    borderColor: borderColor,
    shadowColor: shadowColor,
  );

  static CustomButton secondary({
    required String text,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    double? height,
    BorderRadius? borderRadius,
    bool disabled = false,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
  }) => CustomButton(
    text: text,
    key: key,
    onPressed: onPressed,
    icon: icon,
    variant: ButtonVariant.secondary,
    alignment: alignment,
    height: height,
    borderRadius: borderRadius,
    disabled: disabled,
    backgroundColor: backgroundColor,
    textColor: textColor,
    borderColor: borderColor,
  );

  static CustomButton ghost({
    required String text,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    double? height,
    BorderRadius? borderRadius,
  }) => CustomButton(
    text: text,
    key: key,
    onPressed: onPressed,
    icon: icon,
    variant: ButtonVariant.ghost,
    alignment: alignment,
    height: height,
    borderRadius: borderRadius,
    disabled: true,
  );
}
