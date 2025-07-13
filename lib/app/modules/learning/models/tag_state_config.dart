import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/constants.dart';

/// Configuration for different tag states in multiple select questions
class TagStateConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final List<BoxShadow> shadows;

  const TagStateConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.shadows,
  });

  // Default unselected state
  static const TagStateConfig defaultState = TagStateConfig(
    backgroundColor: Colors.white,
    borderColor: kButtonSecondaryBorderColor,
    textColor: kButtonSecondaryTextColor,
    shadows: [
      BoxShadow(
        color: kButtonSecondaryTopShadowColor,
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: kButtonSecondaryBottomShadowColor,
        offset: Offset(0, 2),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ],
  );

  // Selected state (grey)
  static const TagStateConfig selectedState = TagStateConfig(
    backgroundColor: Color(0xFFE5E5E5),
    borderColor: Color(0xFFBDBDBD),
    textColor: Color(0xFF757575),
    shadows: [],
  );

  // Correct answer state
  static const TagStateConfig correctState = TagStateConfig(
    backgroundColor: Color(0xFFD3F5DD),
    borderColor: Color(0xFF019B2B),
    textColor: Color(0xFF019B2B),
    shadows: [
      BoxShadow(
        color: Color(0x1A019B2B),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0xFF019B2B),
        offset: Offset(0, 2),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ],
  );

  // Incorrect answer state
  static const TagStateConfig incorrectState = TagStateConfig(
    backgroundColor: Color(0xFFFEE5E5),
    borderColor: Color(0xFFB71C1C),
    textColor: Color(0xFFB71C1C),
    shadows: [
      BoxShadow(
        color: Color(0x1AB71C1C),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0xFFB71C1C),
        offset: Offset(0, 2),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ],
  );

  // Unselected correct option state
  static const TagStateConfig unselectedCorrectState = TagStateConfig(
    backgroundColor: Color(0xFFE8F5E9),
    borderColor: Color(0xFF4CAF50),
    textColor: Color(0xFF4CAF50),
    shadows: [
      BoxShadow(
        color: Color(0x1A4CAF50),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0xFF4CAF50),
        offset: Offset(0, 2),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ],
  );
}