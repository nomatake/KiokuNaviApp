import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/app/bindings/service_binding.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/app/modules/home/controllers/child_home_controller.dart';
import 'package:kioku_navi/app/modules/home/controllers/parent_dashboard_controller.dart';
import 'package:kioku_navi/services/connectivity/connectivity_service.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/utils/error_manager.dart';
import 'package:splash_master/splash_master.dart';

class ConfigStore extends GetxController {
  static ConfigStore get to => Get.find();

  // Platform information
  String get version => '1.0.0';
  bool get isRelease => true;

  // App Name
  static const String appName = kAppName;

  // Locale configuration
  static const Locale locale = Locale('ja', 'JP');

  // Fallback locale
  static const Locale fallbackLocale = Locale('en', 'US');

  // Languages configuration
  List<Locale> languages = [
    const Locale('en', 'US'),
    const Locale('ja', 'JP'),
  ];

  // Localization Configuration
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ja', 'JP'),
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

  // Lottie Configuration
  static const lottieConfig = LottieConfig(
    width: 300.0,
    height: 300.0,
    visibilityEnum: VisibilityEnum.none,
    fit: BoxFit.contain,
    overrideBoxFit: false,
    repeat: true,
  );

  static Future<void> initializeServices() async {
    // Initialize WidgetsFlutterBinding
    WidgetsFlutterBinding.ensureInitialized();

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Initialize SplashMaster
    SplashMaster.initialize();

    // Initialize GetStorage
    await GetStorage.init();

    // Initialize services (this includes connectivity service and manager)
    ServiceBinding().dependencies();

    // Initialize connectivity service
    final connectivityService = Get.find<ConnectivityService>();
    await connectivityService.initialize();

    // Initialize error manager
    Get.put(ErrorManager());

    // Pre-register controllers that might be needed after splash
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => ChildHomeController());
    Get.lazyPut(() => ParentDashboardController());
  }
}
