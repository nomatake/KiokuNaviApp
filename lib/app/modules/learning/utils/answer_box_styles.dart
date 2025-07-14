import 'package:flutter/material.dart';

/// Utility class for answer box styling calculations
class AnswerBoxStyles {
  // Active selection colors
  static const Color activeBackgroundColor = Color(0xFFE3F2FD);
  static const Color activeBorderColor = Color(0xFF2196F3);
  static const Color activeShadowColor = Color(0x1A2196F3);
  
  // Default colors
  static const Color defaultBackgroundColor = Colors.white;
  static const Color defaultBorderColor = Color(0xFFB0BEC5);
  static const Color defaultShadowColor = Color(0x1A757575);
  static const Color defaultTextColor = Color(0xFF424242);
  
  // Correct answer colors
  static const Color correctBackgroundColor = Color(0xFFD3F5DD);
  static const Color correctBorderColor = Color(0xFF019B2B);
  static const Color correctShadowColor = Color(0x1A019B2B);
  static const Color correctTextColor = Color(0xFF019B2B);
  
  // Incorrect answer colors
  static const Color incorrectBackgroundColor = Color(0xFFFEE5E5);
  static const Color incorrectBorderColor = Color(0xFFB71C1C);
  static const Color incorrectShadowColor = Color(0x1AB71C1C);
  static const Color incorrectTextColor = Color(0xFFB71C1C);
  
  /// Get answer box colors based on state
  static AnswerBoxColorSet getColors({
    required bool isActive,
    required bool hasSubmitted,
    required String? selectedChoice,
    required String? correctChoice,
    required String questionKey,
  }) {
    // Active selection state
    if (isActive) {
      return AnswerBoxColorSet(
        backgroundColor: activeBackgroundColor,
        borderColor: activeBorderColor,
        shadowColor: activeShadowColor,
        textColor: defaultTextColor,
      );
    }
    
    // After submission
    if (hasSubmitted && selectedChoice != null) {
      final isCorrect = selectedChoice == correctChoice;
      return AnswerBoxColorSet(
        backgroundColor: isCorrect ? correctBackgroundColor : incorrectBackgroundColor,
        borderColor: isCorrect ? correctBorderColor : incorrectBorderColor,
        shadowColor: isCorrect ? correctShadowColor : incorrectShadowColor,
        textColor: isCorrect ? correctTextColor : incorrectTextColor,
      );
    }
    
    // Default state
    return AnswerBoxColorSet(
      backgroundColor: defaultBackgroundColor,
      borderColor: defaultBorderColor,
      shadowColor: defaultShadowColor,
      textColor: defaultTextColor,
    );
  }
}

/// Container for answer box colors
class AnswerBoxColorSet {
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;
  final Color textColor;
  
  const AnswerBoxColorSet({
    required this.backgroundColor,
    required this.borderColor,
    required this.shadowColor,
    required this.textColor,
  });
}