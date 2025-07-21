import 'package:flutter/material.dart';
import 'package:kioku_navi/app/core/values/app_colors.dart';
import 'package:kioku_navi/utils/app_constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/responsive_wrapper.dart';
import 'package:kioku_navi/widgets/chiclet.dart';
import 'package:kioku_navi/widgets/answer_chiclet_button.dart';

class CustomChicletButton extends StatelessWidget {
  /// Primary button - filled with primary color
  factory CustomChicletButton.primary({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.primary,
        textAlign: textAlign,
      );

  /// Secondary button - outlined with secondary color
  factory CustomChicletButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.secondary,
        textAlign: textAlign,
      );

  /// Outline button - outlined with primary color
  factory CustomChicletButton.outline({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.outline,
        textAlign: textAlign,
      );

  /// Danger button - filled with danger/red color
  factory CustomChicletButton.danger({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.danger,
        textAlign: textAlign,
      );

  /// Success button - filled with success/green color
  factory CustomChicletButton.success({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.success,
        textAlign: textAlign,
      );

  /// Orange button - filled with orange color
  factory CustomChicletButton.orange({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.orange,
        textAlign: textAlign,
      );

  /// Ghost button - disabled style button
  factory CustomChicletButton.ghost({
    required String text,
    Key? key,
    VoidCallback? onPressed,
    Widget? icon,
    double? width,
    double? height,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: false,
        disabled: disabled,
        style: ChicletButtonStyle.ghost,
        textAlign: textAlign,
      );

  /// Answer None button - for unselected answer options
  factory CustomChicletButton.answerNone({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.answerNone,
        textAlign: textAlign,
      );

  /// Answer Selected button - for selected answer options
  factory CustomChicletButton.answerSelected({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.answerSelected,
        textAlign: textAlign,
      );

  /// Answer Correct button - for correct answer options
  factory CustomChicletButton.answerCorrect({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.answerCorrect,
        textAlign: textAlign,
      );

  /// Answer Incorrect button - for incorrect answer options
  factory CustomChicletButton.answerIncorrect({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.answerIncorrect,
        textAlign: textAlign,
      );

  /// Answer Disabled button - for unselected options after submission
  factory CustomChicletButton.answerDisabled({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    Widget? icon,
    double? width,
    double? height,
    bool isPressed = false,
    bool disabled = false,
    TextAlign textAlign = TextAlign.center,
  }) =>
      CustomChicletButton._(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        width: width,
        height: height,
        isPressed: isPressed,
        disabled: disabled,
        style: ChicletButtonStyle.answerDisabled,
        textAlign: textAlign,
      );

  const CustomChicletButton._({
    required this.text,
    required this.style,
    super.key,
    this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.isPressed = false,
    this.disabled = false,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double? width;
  final double? height;
  final bool isPressed;
  final bool disabled;
  final ChicletButtonStyle style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    // Get responsive values
    final effectiveHeight =
        height ?? ResponsivePatterns.buttonHeight.getValueForContext(context);
    final baseFontSize =
        ResponsivePatterns.bodyFontSize.getValue(context.screenInfo).sp;

    // Get style configuration
    final config = _getStyleConfig(disabled: disabled);

    // Build child widget
    final child = _buildChild(
      text: text,
      icon: icon,
      textStyle: TextStyle(
        fontFamily: 'Hiragino Sans',
        fontWeight: config.fontWeight,
        fontSize: baseFontSize,
        color: disabled ? null : config.foregroundColor,
        letterSpacing: config.letterSpacing,
      ),
      textAlign: textAlign,
    );

    // Return outlined button for secondary, outline, and answer styles
    final isOutlined = style == ChicletButtonStyle.secondary ||
        style == ChicletButtonStyle.outline ||
        style == ChicletButtonStyle.answerNone ||
        style == ChicletButtonStyle.answerSelected ||
        style == ChicletButtonStyle.answerCorrect ||
        style == ChicletButtonStyle.answerIncorrect ||
        style == ChicletButtonStyle.answerDisabled;

    // For answer buttons (except answerDisabled), preserve visual state even when disabled
    final isAnswerButton = style == ChicletButtonStyle.answerNone ||
        style == ChicletButtonStyle.answerSelected ||
        style == ChicletButtonStyle.answerCorrect ||
        style == ChicletButtonStyle.answerIncorrect;

    // For answer buttons, use the specialized AnswerChicletButton
    if (isAnswerButton || style == ChicletButtonStyle.answerDisabled) {
      return AnswerChicletButton(
        text: text,
        onPressed: disabled ? null : onPressed,
        backgroundColor: config.backgroundColor!,
        borderColor: config.borderColor!,
        buttonColor: config.buttonColor!,
        foregroundColor: config.foregroundColor,
        width: width ?? double.infinity,
        height: effectiveHeight,
        buttonHeight: config.buttonHeight,
        borderWidth: config.borderWidth ?? 2,
        borderRadius: AppBorderRadius.button,
      );
    }

    // For non-answer outlined buttons
    if (isOutlined) {
      return ChicletOutlinedAnimatedButton(
        onPressed: disabled ? null : onPressed,
        backgroundColor: config.backgroundColor,
        borderColor: config.borderColor,
        buttonColor: config.buttonColor,
        foregroundColor: config.foregroundColor,
        disabledBackgroundColor: AppColors.Common.DisabledBackgroundColor,
        disabledBorderColor: AppColors.Common.DisabledBorderColor,
        disabledForegroundColor: AppColors.Common.DisabledTextColor,
        width: width ?? double.infinity,
        height: effectiveHeight,
        buttonHeight: config.buttonHeight,
        borderWidth: config.borderWidth ?? 2,
        borderRadius: AppBorderRadius.button,
        isPressed: isPressed,
        disabledShowsPressed: true,
        child: child,
      );
    }

    return ChicletAnimatedButton(
      onPressed: disabled ? null : onPressed,
      backgroundColor: config.backgroundColor,
      buttonColor: config.buttonColor,
      foregroundColor: config.foregroundColor,
      disabledBackgroundColor: isAnswerButton 
          ? config.backgroundColor 
          : AppColors.Common.DisabledBackgroundColor,
      disabledForegroundColor: isAnswerButton 
          ? config.foregroundColor 
          : AppColors.Common.DisabledTextColor,
      width: width ?? double.infinity,
      height: effectiveHeight,
      buttonHeight: config.buttonHeight,
      borderRadius: AppBorderRadius.button,
      isPressed: isPressed,
      disabledShowsPressed: false,
      child: child,
    );
  }

  /// Build child widget with optional icon
  Widget _buildChild({
    required String text,
    required Widget? icon,
    required TextStyle textStyle,
    required TextAlign textAlign,
  }) {
    final textWidget = Text(text, style: textStyle, textAlign: textAlign);

    // If no icon, wrap text in Align widget to make textAlign work
    if (icon == null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Align(
          alignment: _getAlignmentFromTextAlign(textAlign),
          child: textWidget,
        ),
      );
    }

    // With icon, use Row with alignment based on textAlign
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: _getMainAxisAlignmentFromTextAlign(textAlign),
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          if (text.isNotEmpty) ...[
            SizedBox(width: AppSpacing.xxxs.wp),
            textWidget,
          ],
        ],
      ),
    );
  }

  /// Convert TextAlign to Alignment for Align widget
  Alignment _getAlignmentFromTextAlign(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.left:
      case TextAlign.start:
        return Alignment.centerLeft;
      case TextAlign.right:
      case TextAlign.end:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.justify:
        return Alignment.center;
    }
  }

  /// Convert TextAlign to MainAxisAlignment for Row widget
  MainAxisAlignment _getMainAxisAlignmentFromTextAlign(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.left:
      case TextAlign.start:
        return MainAxisAlignment.start;
      case TextAlign.right:
      case TextAlign.end:
        return MainAxisAlignment.end;
      case TextAlign.center:
      case TextAlign.justify:
        return MainAxisAlignment.center;
    }
  }

  _ChicletButtonConfig _getStyleConfig({bool disabled = false}) {
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
      case ChicletButtonStyle.answerNone:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Answer.None.Background,
          borderColor: AppColors.Button.Answer.None.Border,
          buttonColor: AppColors.Button.Answer.None.Shadow,
          foregroundColor: AppColors.Button.Answer.None.Text,
          fontWeight: FontWeight.w700,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: outlinedButtonHeight,
          borderWidth: outlinedBorderWidth,
        );
      case ChicletButtonStyle.answerSelected:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Answer.Selected.Background,
          borderColor: AppColors.Button.Answer.Selected.Border,
          buttonColor: AppColors.Button.Answer.Selected.Shadow,
          foregroundColor: AppColors.Button.Answer.Selected.Text,
          fontWeight: FontWeight.w700,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: outlinedButtonHeight,
          borderWidth: outlinedBorderWidth,
        );
      case ChicletButtonStyle.answerCorrect:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Answer.Correct.Background,
          borderColor: AppColors.Button.Answer.Correct.Border,
          buttonColor: AppColors.Button.Answer.Correct.Shadow,
          foregroundColor: AppColors.Button.Answer.Correct.Text,
          fontWeight: FontWeight.w700,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: outlinedButtonHeight,
          borderWidth: outlinedBorderWidth,
        );
      case ChicletButtonStyle.answerIncorrect:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Answer.Incorrect.Background,
          borderColor: AppColors.Button.Answer.Incorrect.Border,
          buttonColor: AppColors.Button.Answer.Incorrect.Shadow,
          foregroundColor: AppColors.Button.Answer.Incorrect.Text,
          fontWeight: FontWeight.w700,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: outlinedButtonHeight,
          borderWidth: outlinedBorderWidth,
        );
      case ChicletButtonStyle.answerDisabled:
        return _ChicletButtonConfig(
          backgroundColor: AppColors.Button.Answer.Disabled.Background,
          borderColor: AppColors.Button.Answer.Disabled.Border,
          buttonColor: AppColors.Button.Answer.Disabled.Shadow,
          foregroundColor: AppColors.Button.Answer.Disabled.Text,
          fontWeight: FontWeight.w700,
          letterSpacing: defaultLetterSpacing,
          buttonHeight: outlinedButtonHeight,
          borderWidth: outlinedBorderWidth,
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
  answerNone,
  answerSelected,
  answerCorrect,
  answerIncorrect,
  answerDisabled,
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
