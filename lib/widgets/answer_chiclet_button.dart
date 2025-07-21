import 'package:flutter/material.dart';
import 'package:kioku_navi/widgets/chiclet/chiclet_outlined_animated_button.dart';

/// A specialized chiclet button for answer options that always shows shadows
class AnswerChicletButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color buttonColor;
  final Color foregroundColor;
  final double? width;
  final double? height;
  final double buttonHeight;
  final double borderWidth;
  final double borderRadius;

  const AnswerChicletButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    required this.buttonColor,
    required this.foregroundColor,
    this.width,
    this.height,
    this.buttonHeight = 3.0,
    this.borderWidth = 2.0,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    // Always show the button with shadow, even when disabled
    Widget button = ChicletOutlinedAnimatedButton(
      onPressed: onPressed ?? () {}, // Never null to ensure shadow
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      buttonColor: buttonColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: backgroundColor,
      disabledBorderColor: borderColor,
      disabledForegroundColor: foregroundColor,
      width: width ?? double.infinity,
      height: height ?? 50.0,
      buttonHeight: buttonHeight,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      isPressed: false, // Always false to show shadow
      disabledShowsPressed: false, // Never show pressed state when disabled
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Hiragino Sans',
              fontWeight: FontWeight.w700,
              color: foregroundColor,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );

    // If disabled, wrap in IgnorePointer
    if (onPressed == null) {
      return IgnorePointer(child: button);
    }

    return button;
  }
}