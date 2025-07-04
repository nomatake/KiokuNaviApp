import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

class AccessibilityHelper {
  static const double _minTapTargetSize = 48.0;
  static const double _maxTextScaleFactor = 2.0;
  static const double _minTextScaleFactor = 0.8;

  /// Ensures minimum tap target size for accessibility
  static Size getMinimumTapTargetSize(Size originalSize) {
    return Size(
      originalSize.width < _minTapTargetSize
          ? _minTapTargetSize
          : originalSize.width,
      originalSize.height < _minTapTargetSize
          ? _minTapTargetSize
          : originalSize.height,
    );
  }

  /// Clamps text scale factor to prevent text from being too large or too small
  static double getAccessibleTextScaleFactor(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaler.scale(1.0);
    return textScaleFactor.clamp(_minTextScaleFactor, _maxTextScaleFactor);
  }

  /// Provides appropriate semantic label for buttons
  static String getButtonSemanticLabel(String text, {String? hint}) {
    if (hint != null) {
      return '$text, $hint';
    }
    return text;
  }

  /// Provides semantic label for progress indicators
  static String getProgressSemanticLabel(double progress) {
    final percentage = (progress * 100).round();
    return '$percentage%の進捗';
  }

  /// Provides semantic label for course nodes
  static String getCourseNodeSemanticLabel(String title, double progress) {
    final percentage = (progress * 100).round();
    return '$title、$percentage%完了';
  }

  /// Provides haptic feedback for interactions
  static void provideTapFeedback() {
    HapticFeedback.lightImpact();
  }

  /// Provides stronger haptic feedback for important actions
  static void provideSelectionFeedback() {
    HapticFeedback.mediumImpact();
  }

  /// Provides error haptic feedback
  static void provideErrorFeedback() {
    HapticFeedback.heavyImpact();
  }

  /// Announces text to screen readers
  static void announceMessage(BuildContext context, String message) {
    if (context.mounted) {
      SemanticsService.announce(message, TextDirection.ltr);
    }
  }

  /// Creates accessible widget with proper semantics
  static Widget makeAccessible({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
    bool excludeSemantics = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: onTap != null,
      excludeSemantics: excludeSemantics,
      child: child,
    );
  }

  /// Creates accessible text with proper contrast
  static Widget createAccessibleText({
    required String text,
    required TextStyle style,
    String? semanticsLabel,
    int? maxLines,
    TextAlign? textAlign,
  }) {
    return Semantics(
      label: semanticsLabel ?? text,
      child: Text(
        text,
        style: style,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      ),
    );
  }

  /// Creates accessible button with proper tap target size
  static Widget createAccessibleButton({
    required Widget child,
    required VoidCallback? onPressed,
    required String semanticsLabel,
    String? semanticsHint,
    EdgeInsets? padding,
    double? minWidth,
    double? minHeight,
  }) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      button: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? _minTapTargetSize,
          minHeight: minHeight ?? _minTapTargetSize,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }

  /// Checks if high contrast mode is enabled
  static bool isHighContrastMode(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  /// Checks if user prefers reduced motion
  static bool isReducedMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Gets appropriate animation duration based on accessibility settings
  static Duration getAccessibleAnimationDuration(BuildContext context) {
    if (isReducedMotionEnabled(context)) {
      return Duration.zero;
    }
    return const Duration(milliseconds: 300);
  }

  /// Creates accessible form field with proper semantics
  static Widget createAccessibleFormField({
    required Widget child,
    required String label,
    bool isRequired = false,
    String? errorText,
    String? hint,
  }) {
    final semanticsLabel = isRequired ? '$label (必須)' : label;
    final semanticsHint = hint != null 
        ? (errorText != null ? '$hint。エラー: $errorText' : hint)
        : errorText;

    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      textField: true,
      child: child,
    );
  }
}