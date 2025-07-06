import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/views/root_screen_view.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/utils/error_manager.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:splash_master/splash_master.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SplashMaster.initialize();

  // Initialize error manager
  Get.put(ErrorManager());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(kScaffoldBackgroundColor),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white70,
      scrolledUnderElevation: k0Double,
      elevation: k0Double,
    ),
  );

  static const _localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const _supportedLocales = [
    Locale('en', ''),
    Locale('ja', ''),
  ];

  static const _lottieConfig = LottieConfig(
    width: 300.0,
    height: 300.0,
    visibilityEnum: VisibilityEnum.none,
    fit: BoxFit.contain,
    overrideBoxFit: false,
    repeat: true,
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashMaster.lottie(
        source: AssetSource('assets/lottie/learning.json'),
        nextScreen: const RootScreenView(),
        backGroundColor: Colors.white,
        lottieConfig: _lottieConfig,
      ),
      title: kAppName,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      theme: _theme,
      defaultTransition: Transition.noTransition,
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: _supportedLocales,
      locale: const Locale('ja', ''),
    );
  }
}
