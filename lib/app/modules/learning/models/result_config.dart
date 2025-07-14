import 'package:flutter/material.dart';

class ResultConfig {
  final Color backgroundColor;
  final IconData iconData;
  final Color iconColor;
  final String text;
  final Color textColor;
  final String buttonText;
  final Widget Function(String text, VoidCallback onPressed) buttonBuilder;
  final VoidCallback onButtonPressed;

  const ResultConfig({
    required this.backgroundColor,
    required this.iconData,
    required this.iconColor,
    required this.text,
    required this.textColor,
    required this.buttonText,
    required this.buttonBuilder,
    required this.onButtonPressed,
  });
}