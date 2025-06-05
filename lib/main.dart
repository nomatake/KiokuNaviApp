import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kioku_navi/utils/constants.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
    ),
  );
}
