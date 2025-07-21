// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  
  static const Button = _Button();
  static const Common = _Common();
}

class _Common {
  const _Common();
  
  final Color White = const Color(0xFFFFFFFF);
  final Color DisabledBackgroundColor = const Color(0xFFE5E5E5);
  final Color DisabledTextColor = const Color(0xFFAFAFAF);
  final Color DisabledShadowColor = const Color(0x33000000);
  final Color DisabledBorderColor = const Color(0xFFAFAFAF);
}

class _Button {
  const _Button();
  
  final Primary = const _Primary();
  final Secondary = const _Secondary();
  final Outline = const _Outline();
  final Danger = const _Danger();
  final Success = const _Success();
  final Orange = const _Orange();
  final Ghost = const _Ghost();
  final Answer = const _Answer();
}

class _Primary {
  const _Primary();
  
  final Color Background = const Color(0xFF3D95E6);
  final Color Shadow = const Color(0xFF1976D2);
}

class _Secondary {
  const _Secondary();
  
  final Color Background = const Color(0xFFFFFFFF);
  final Color Border = const Color(0xFFB0BEC5);
  final Color Text = const Color(0xFF424242);
}

class _Outline {
  const _Outline();
  
  final Color Background = const Color(0xFFFFFFFF);
  final Color Border = const Color(0xFF1E88E5);
  final Color Text = const Color(0xFF1976D2);
}

class _Danger {
  const _Danger();
  
  final Color Background = const Color(0xFFE53935);
  final Color Shadow = const Color(0xFFC62828);
}

class _Success {
  const _Success();
  
  final Color Background = const Color(0xFF29CC57);
  final Color Shadow = const Color(0xFF15B440);
}

class _Orange {
  const _Orange();
  
  final Color Background = const Color(0xFFF57C00);
  final Color Shadow = const Color(0xFFE56A00);
}

class _Ghost {
  const _Ghost();
  
  final Color Background = const Color(0xFFE5E5E5);
  final Color Shadow = const Color(0x33000000);
  final Color Text = const Color(0xFFAFAFAF);
}

class _Answer {
  const _Answer();
  
  final None = const _AnswerNone();
  final Selected = const _AnswerSelected();
  final Correct = const _AnswerCorrect();
  final Incorrect = const _AnswerIncorrect();
  final Disabled = const _AnswerDisabled();
}

class _AnswerNone {
  const _AnswerNone();
  
  final Color Background = Colors.white;
  final Color Border = const Color(0xFFB0BEC5);
  final Color Shadow = const Color(0xFFB0BEC5);
  final Color Text = const Color(0xFF424242);
}

class _AnswerSelected {
  const _AnswerSelected();
  
  final Color Background = const Color(0xFFE3F2FD);
  final Color Border = const Color(0xFF1976D2);
  final Color Shadow = const Color(0xFF1976D2);
  final Color Text = const Color(0xFF424242);
}

class _AnswerCorrect {
  const _AnswerCorrect();
  
  final Color Background = const Color(0xFFD3F5DD);
  final Color Border = const Color(0xFF15B440);
  final Color Shadow = const Color(0xFF15B440);
  final Color Text = const Color(0xFF019B2B);
}

class _AnswerIncorrect {
  const _AnswerIncorrect();
  
  final Color Background = const Color(0xFFFEE5E5);
  final Color Border = const Color(0xFFE53935);
  final Color Shadow = const Color(0xFFE53935);
  final Color Text = const Color(0xFFB71C1C);
}

class _AnswerDisabled {
  const _AnswerDisabled();
  
  final Color Background = const Color(0xFFF5F5F5);
  final Color Border = const Color(0xFFE0E0E0);
  final Color Shadow = const Color(0xFFE0E0E0);
  final Color Text = const Color(0xFF9E9E9E);
}