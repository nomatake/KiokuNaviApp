import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/config/config_store.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/utils/route_helper.dart';
import 'package:splash_master/splash_master.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize services
  await ConfigStore.initializeServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashMaster.lottie(
        source: AssetSource(Assets.lottie.learning),
        nextScreen: RouteHelper.getInitialScreen(),
        backGroundColor: Colors.white,
        lottieConfig: ConfigStore.lottieConfig,
      ),
      title: kAppName,
      getPages: AppPages.routes,
      theme: ConfigStore.theme,
      defaultTransition: Transition.noTransition,
      localizationsDelegates: ConfigStore.localizationsDelegates,
      supportedLocales: ConfigStore.supportedLocales,
      locale: ConfigStore.locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
