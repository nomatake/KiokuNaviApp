import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

enum ButtonTextAlignment { start, centerLeft, center, centerRight, end }

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
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
    this.borderRadius,
  });

  // Common shadow configurations
  static const _defaultTopShadow = BoxShadow(
    color: kButtonDefaultTopShadowColor,
    blurRadius: 2,
    offset: Offset(0, 1),
  );

  static const _disabledShadow = BoxShadow(
    color: kButtonDisabledShadowColor,
    offset: Offset(0, 4),
    blurRadius: 0,
    spreadRadius: 0,
  );

  // Button style configurations
  static const _orangeConfig = _ButtonConfig(
    buttonColor: kButtonOrangeColor,
    textColor: Colors.white,
    shadowColor: kButtonOrangeShadowColor,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    shadowOffset: Offset(0, 4),
  );

  static const _successConfig = _ButtonConfig(
    buttonColor: kButtonSuccessColor,
    textColor: Colors.white,
    shadowColor: kButtonSuccessShadowColor,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    shadowOffset: Offset(0, 4),
  );

  static const _dangerConfig = _ButtonConfig(
    buttonColor: kButtonDangerColor,
    textColor: Colors.white,
    shadowColor: kButtonDangerShadowColor,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    shadowOffset: Offset(0, 4),
  );

  static const _secondaryTopShadow = BoxShadow(
    color: kButtonSecondaryTopShadowColor,
    blurRadius: 2,
    offset: Offset(0, 1),
  );

  static const _secondaryBottomShadow = BoxShadow(
    color: kButtonSecondaryBottomShadowColor,
    offset: Offset(0, 3),
    blurRadius: 0,
    spreadRadius: 0,
  );

  // Factory constructor helper method
  static CustomButton _createButton({
    required String text,
    required _ButtonConfig config,
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
    BorderRadius? borderRadius,
  }) {
    final effectiveShadowColor = shadowColor ?? config.shadowColor;
    return CustomButton(
      text: text,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? config.buttonColor,
      textColor: textColor ?? config.textColor,
      shadowColor: effectiveShadowColor,
      contentPadding: contentPadding,
      height: height,
      disabled: disabled,
      fontWeight: config.fontWeight,
      letterSpacing: config.letterSpacing,
      textAlignment: textAlignment,
      borderRadius: borderRadius,
      shadows: [
        _defaultTopShadow,
        BoxShadow(
          color: effectiveShadowColor,
          offset: config.shadowOffset,
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Factory constructors
  factory CustomButton.orange({
    required String text,
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
    BorderRadius? borderRadius,
  }) =>
      _createButton(
        text: text,
        config: _orangeConfig,
        key: key,
        onPressed: onPressed,
        icon: icon,
        buttonColor: buttonColor,
        textColor: textColor,
        shadowColor: shadowColor,
        contentPadding: contentPadding,
        height: height,
        disabled: disabled,
        textAlignment: textAlignment,
        borderRadius: borderRadius,
      );

  factory CustomButton.success({
    required String text,
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
    BorderRadius? borderRadius,
  }) =>
      _createButton(
        text: text,
        config: _successConfig,
        key: key,
        onPressed: onPressed,
        icon: icon,
        buttonColor: buttonColor,
        textColor: textColor,
        shadowColor: shadowColor,
        contentPadding: contentPadding,
        height: height,
        disabled: disabled,
        textAlignment: textAlignment,
        borderRadius: borderRadius,
      );

  factory CustomButton.danger({
    required String text,
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
    BorderRadius? borderRadius,
  }) =>
      _createButton(
        text: text,
        config: _dangerConfig,
        key: key,
        onPressed: onPressed,
        icon: icon,
        buttonColor: buttonColor,
        textColor: textColor,
        shadowColor: shadowColor,
        contentPadding: contentPadding,
        height: height,
        disabled: disabled,
        textAlignment: textAlignment,
        borderRadius: borderRadius,
      );

  factory CustomButton.primary({
    required String text,
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
    BorderRadius? borderRadius,
  }) {
    final effectiveShadowColor = shadowColor ?? kButtonPrimaryColor;
    return CustomButton(
      text: text,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? kButtonPrimaryColor.withValues(alpha: 0.8),
      textColor: textColor ?? Colors.white,
      shadowColor: effectiveShadowColor,
      contentPadding: contentPadding,
      height: height,
      disabled: disabled,
      fontWeight: FontWeight.w800,
      letterSpacing: k1Double.sp,
      textAlignment: textAlignment,
      borderRadius: borderRadius,
      shadows: [
        _defaultTopShadow,
        BoxShadow(
          color: effectiveShadowColor,
          offset: const Offset(0, 5),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }

  factory CustomButton.outline({
    required String text,
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
    BorderRadius? borderRadius,
  }) {
    final effectiveShadowColor = shadowColor ?? kButtonPrimaryColor;
    return CustomButton(
      text: text,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? Colors.transparent,
      textColor: textColor ?? kButtonOutlineTextColor,
      borderColor: borderColor ?? kButtonPrimaryColor,
      shadowColor: effectiveShadowColor,
      contentPadding: contentPadding,
      height: height,
      disabled: disabled,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      borderWidth: borderWidth ?? 2,
      textAlignment: textAlignment,
      borderRadius: borderRadius,
      shadows: [
        _defaultTopShadow,
        BoxShadow(
          color: effectiveShadowColor,
          offset: const Offset(0, 3),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ],
    );
  }

  factory CustomButton.secondary({
    required String text,
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
    BorderRadius? borderRadius,
  }) {
    return CustomButton(
      text: text,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? Colors.white,
      textColor: textColor ?? kButtonSecondaryTextColor,
      borderColor: borderColor ?? kButtonSecondaryBorderColor,
      contentPadding: contentPadding,
      height: height,
      disabled: disabled,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      borderWidth: borderWidth ?? 2,
      textAlignment: textAlignment,
      borderRadius: borderRadius,
      shadows: const [_secondaryTopShadow, _secondaryBottomShadow],
    );
  }

  factory CustomButton.ghost({
    required String text,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    Color? buttonColor,
    Color? textColor,
    EdgeInsetsGeometry? contentPadding,
    double? height,
    ButtonTextAlignment textAlignment = ButtonTextAlignment.center,
    BorderRadius? borderRadius,
  }) {
    return CustomButton(
      text: text,
      key: key,
      onPressed: onPressed,
      icon: icon,
      buttonColor: buttonColor ?? kButtonDisabledColor,
      textColor: textColor ?? kButtonDisabledTextColor,
      contentPadding: contentPadding,
      height: height,
      disabled: true,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      textAlignment: textAlignment,
      borderRadius: borderRadius,
      shadows: null,
    );
  }

  final String text;
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
  final BorderRadius? borderRadius;

  static const _alignmentMap = {
    ButtonTextAlignment.start: Alignment.centerLeft,
    ButtonTextAlignment.centerLeft: Alignment(-0.65, 0),
    ButtonTextAlignment.center: Alignment.center,
    ButtonTextAlignment.centerRight: Alignment(0.65, 0),
    ButtonTextAlignment.end: Alignment.centerRight,
  };

  EdgeInsets _getTextPadding() {
    switch (textAlignment) {
      case ButtonTextAlignment.start:
      case ButtonTextAlignment.centerLeft:
        return EdgeInsets.only(left: k4Double.wp);
      case ButtonTextAlignment.centerRight:
      case ButtonTextAlignment.end:
        return EdgeInsets.only(right: k4Double.wp);
      case ButtonTextAlignment.center:
        return EdgeInsets.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveButtonColor = buttonColor ?? Colors.blue;
    final effectiveTextColor =
        disabled ? kButtonDisabledTextColor : (textColor ?? Colors.white);
    final effectiveBorderColor = borderColor;
    final effectiveHeight = height ?? 48;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);

    final textWidget = Text(
      text,
      style: TextStyle(
        fontFamily: 'Hiragino Sans',
        fontWeight: fontWeight ?? FontWeight.w500,
        fontSize: k12Double.sp,
        color: effectiveTextColor,
        letterSpacing: letterSpacing ?? 0,
      ),
    );

    final content = Row(
      children: [
        if (icon != null) ...[
          icon!,
          if (text.isNotEmpty) SizedBox(width: k1Double.wp),
        ],
        if (text.isNotEmpty)
          Expanded(
            child: Align(
              alignment: _alignmentMap[textAlignment]!,
              child: Padding(
                padding: _getTextPadding(),
                child: textWidget,
              ),
            ),
          ),
      ],
    );

    // For icon-only buttons, center the icon
    final finalContent =
        (icon != null && text.isEmpty) ? Center(child: icon) : content;

    if (disabled) {
      return SizedBox(
        width: double.infinity,
        height: effectiveHeight,
        child: Container(
          decoration: BoxDecoration(
            color: kButtonDisabledColor,
            borderRadius: effectiveBorderRadius,
            boxShadow: const [_disabledShadow],
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: kButtonDisabledColor,
              borderRadius: effectiveBorderRadius,
            ),
            child: Center(child: finalContent),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: effectiveHeight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: effectiveBorderRadius,
          border: effectiveBorderColor != null
              ? Border.all(
                  color: effectiveBorderColor,
                  width: borderWidth ?? 1,
                )
              : null,
          boxShadow: shadows,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: effectiveBorderRadius,
            child: Ink(
              decoration: BoxDecoration(
                color: effectiveButtonColor,
                borderRadius: effectiveBorderRadius,
              ),
              child: Padding(
                padding: contentPadding ?? EdgeInsets.zero,
                child: finalContent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper class for button configurations
class _ButtonConfig {
  final Color buttonColor;
  final Color textColor;
  final Color shadowColor;
  final FontWeight fontWeight;
  final double letterSpacing;
  final Offset shadowOffset;

  const _ButtonConfig({
    required this.buttonColor,
    required this.textColor,
    required this.shadowColor,
    required this.fontWeight,
    required this.letterSpacing,
    required this.shadowOffset,
  });
}
