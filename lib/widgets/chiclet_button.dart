import 'package:flutter/material.dart';
import 'package:kioku_navi/app/core/values/app_colors.dart';
import 'package:kioku_navi/utils/app_constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/responsive_wrapper.dart';
import 'package:chiclet/chiclet.dart';

class ChicletButton extends StatelessWidget {
  /// Primary button - filled with primary color
  factory ChicletButton.primary({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
  }) =>
      ChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        style: ChicletButtonStyle.primary,
      );

  /// Secondary button - outlined with secondary color
  factory ChicletButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
  }) =>
      ChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        style: ChicletButtonStyle.secondary,
      );

  /// Outline button - outlined with primary color
  factory ChicletButton.outline({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
  }) =>
      ChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        style: ChicletButtonStyle.outline,
      );

  /// Danger button - filled with danger/red color
  factory ChicletButton.danger({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
  }) =>
      ChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        style: ChicletButtonStyle.danger,
      );

  /// Success button - filled with success/green color
  factory ChicletButton.success({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
  }) =>
      ChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        style: ChicletButtonStyle.success,
      );

  /// Orange button - filled with orange color
  factory ChicletButton.orange({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
  }) =>
      ChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        style: ChicletButtonStyle.orange,
      );

  /// Ghost button - disabled style button
  factory ChicletButton.ghost({
    required String text,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    double? width,
    double? height,
  }) =>
      ChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: false,
        style: ChicletButtonStyle.ghost,
      );

  const ChicletButton._({
    required this.text,
    required this.style,
    super.key,
    this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.isPressed = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double? width;
  final double? height;
  final bool isPressed;
  final ChicletButtonStyle style;

  @override
  Widget build(BuildContext context) {
    // Get responsive values
    final effectiveHeight = height ?? ResponsivePatterns.buttonHeight.getValueForContext(context);
    final baseFontSize = ResponsivePatterns.bodyFontSize.getValue(context.screenInfo).sp;
    
    // Get style configuration
    final config = _getStyleConfig();
    
    // Build child widget
    final child = _buildChild(
      text: text,
      icon: icon,
      textStyle: TextStyle(
        fontFamily: 'Hiragino Sans',
        fontWeight: config.fontWeight,
        fontSize: baseFontSize,
        color: config.foregroundColor,
        letterSpacing: config.letterSpacing,
      ),
    );
    
    // Return outlined button for secondary and outline styles
    final isOutlined = style == ChicletButtonStyle.secondary || style == ChicletButtonStyle.outline;
    
    if (isOutlined) {
      return ChicletOutlinedAnimatedButton(
        onPressed: onPressed,
        backgroundColor: config.backgroundColor,
        borderColor: config.borderColor,
        buttonColor: config.buttonColor,
        foregroundColor: config.foregroundColor,
        width: width ?? double.infinity,
        height: effectiveHeight,
        buttonHeight: config.buttonHeight,
        borderWidth: config.borderWidth ?? 2,
        borderRadius: AppBorderRadius.button,
        isPressed: isPressed,
        splashFactory: NoSplash.splashFactory,
        child: child,
      );
    }
    
    return ChicletAnimatedButton(
      onPressed: onPressed,
      backgroundColor: config.backgroundColor,
      buttonColor: config.buttonColor,
      foregroundColor: config.foregroundColor,
      width: width ?? double.infinity,
      height: effectiveHeight,
      buttonHeight: config.buttonHeight,
      borderRadius: AppBorderRadius.button,
      isPressed: isPressed,
      splashFactory: NoSplash.splashFactory,
      child: child,
    );
  }
  
  /// Build child widget with optional icon
  Widget _buildChild({
    required String text,
    required Widget? icon,
    required TextStyle textStyle,
  }) {
    final textWidget = Text(text, style: textStyle);
    
    if (icon == null) return textWidget;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        if (text.isNotEmpty) ...[
          SizedBox(width: AppSpacing.xxxs.wp),
          textWidget,
        ],
      ],
    );
  }

  _ChicletButtonConfig _getStyleConfig() {
    // Common values
    const defaultLetterSpacing = 0.0;
    const filledButtonHeight = 4.0;
    const outlinedButtonHeight = 3.0;
    const outlinedBorderWidth = 2.0;
    
    switch (style) {
      case ChicletButtonStyle.primary:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Primary.Background,
          buttonColor: AppColors.Button.Primary.Shadow,
          foregroundColor: AppColors.Common.White,
          fontWeight: FontWeight.w800,
          letterSpacing: AppSpacing.xxxs.sp,
          buttonHeight: filledButtonHeight,
        );
      case ChicletButtonStyle.secondary:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Secondary.Background,
          borderColor: AppColors.Button.Secondary.Border,
          buttonColor: AppColors.Button.Secondary.Border,
          foregroundColor: AppColors.Button.Secondary.Text,
          fontWeight: FontWeight.w700,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: outlinedButtonHeight,
          borderWidth: outlinedBorderWidth,
        );
      case ChicletButtonStyle.outline:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Outline.Background,
          borderColor: AppColors.Button.Outline.Border,
          buttonColor: AppColors.Button.Outline.Border,
          foregroundColor: AppColors.Button.Outline.Text,
          fontWeight: FontWeight.w700,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: outlinedButtonHeight,
          borderWidth: outlinedBorderWidth,
        );
      case ChicletButtonStyle.danger:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Danger.Background,
          buttonColor: AppColors.Button.Danger.Shadow,
          foregroundColor: AppColors.Common.White,
          fontWeight: FontWeight.w700,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: filledButtonHeight,
        );
      case ChicletButtonStyle.success:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Success.Background,
          buttonColor: AppColors.Button.Success.Shadow,
          foregroundColor: AppColors.Common.White,
          fontWeight: FontWeight.w700,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: filledButtonHeight,
        );
      case ChicletButtonStyle.orange:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Orange.Background,
          buttonColor: AppColors.Button.Orange.Shadow,
          foregroundColor: AppColors.Common.White,
          fontWeight: FontWeight.w700,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: filledButtonHeight,
        );
      case ChicletButtonStyle.ghost:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Ghost.Background,
          buttonColor: AppColors.Button.Ghost.Shadow,
          foregroundColor: AppColors.Button.Ghost.Text,
          fontWeight: FontWeight.w500,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: filledButtonHeight,
        );
    }
  }
}

/// Button style enum
enum ChicletButtonStyle {
  primary,
  secondary,
  outline,
  danger,
  success,
  orange,
  ghost,
}

/// Internal configuration class
class _ChicletButtonConfig {
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? borderColor;
  final Color foregroundColor;
  final FontWeight fontWeight;
  final double letterSpacing;
  final double buttonHeight;
  final double? borderWidth;

  const _ChicletButtonConfig({
    required this.backgroundColor,
    required this.buttonColor,
    required this.foregroundColor,
    required this.fontWeight,
    required this.letterSpacing,
    required this.buttonHeight,
    this.borderColor,
    this.borderWidth,
  });
}
