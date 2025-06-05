import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();
  final passwordController = TextEditingController();

  void onRegister() {
    // TODO: Implement registration logic
  }

  @override
  void onClose() {
    emailController.dispose();
    birthdayController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
