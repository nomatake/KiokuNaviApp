import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/utils/sizes.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: _buildAppTheme(),
      defaultTransition: Transition.noTransition,
    );
  }
}

/// Build the app-wide theme configuration
ThemeData _buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(kScaffoldBackgroundColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // Configure app bar appearance
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white70,
      scrolledUnderElevation: k0Double,
      elevation: k0Double,
    ),
  );
}
