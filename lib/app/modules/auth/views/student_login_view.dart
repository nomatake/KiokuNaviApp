import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/auth/controllers/auth_controller.dart';
import 'package:kioku_navi/widgets/base_login_view.dart';

class StudentLoginView extends GetView<AuthController> {
  const StudentLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLoginView(
      title: "生徒ログイン",
      formKey: controller.studentLoginFormKey,
      controller: controller,
    );
  }
}
