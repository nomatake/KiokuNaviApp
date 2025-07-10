import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/views/root_screen_view.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/config/config_store.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/utils/error_manager.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:splash_master/splash_master.dart';
import 'package:kioku_navi/utils/route_helper.dart';

import 'app/bindings/service_binding.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SplashMaster.initialize();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize services
  ServiceBinding().dependencies();

  // Initialize error manager
  Get.put(ErrorManager());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      initialRoute: RouteHelper.getInitialRoute(),
      getPages: AppPages.routes,
      theme: ConfigStore.theme,
      defaultTransition: Transition.noTransition,
      localizationsDelegates: ConfigStore.localizationsDelegates,
      supportedLocales: ConfigStore.supportedLocales,
      locale: ConfigStore.locale,
    );
  }
}
