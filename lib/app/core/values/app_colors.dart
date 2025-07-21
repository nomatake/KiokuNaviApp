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