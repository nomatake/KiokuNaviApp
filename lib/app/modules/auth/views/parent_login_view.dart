import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/widgets/base_login_view.dart';
import 'package:kioku_navi/generated/locales.g.dart';

class ParentLoginView extends GetView<AuthController> {
  const ParentLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.setupNavigation();

    return BaseLoginView(
      title: LocaleKeys.pages_login_parentTitle.tr,
      formKey: controller.parentLoginFormKey,
      controller: controller,
      onPressed: controller.loginParent,
    );
  }
}
