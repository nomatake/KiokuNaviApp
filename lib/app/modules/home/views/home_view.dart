import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kioku_navi/generated/locales.g.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.pages_home_placeholder.tr),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          LocaleKeys.pages_home_working.tr,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
