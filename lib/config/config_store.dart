import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/constants.dart';

class ConfigStore extends GetxController {
  static ConfigStore get to => Get.find();


  // Platform information
  String get version => '1.0.0';
  bool get isRelease => true;

  // Locale configuration
  static const Locale locale = Locale('ja', '');
  List<Locale> languages = [
    const Locale('en', ''),
    const Locale('ja', ''),
  ];

  // App Theme Configuration
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(kScaffoldBackgroundColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white70,
      scrolledUnderElevation: 0.0,
      elevation: 0.0,
    ),
  );

  // Localization Configuration
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('ja', ''),
  ];


}
