import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final registerFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final dob = TextEditingController();
  final password = TextEditingController();

  void onRegister() {
    // TODO: Implement registration logic
  }

  @override
  void onClose() {
    email.dispose();
    dob.dispose();
    password.dispose();
    super.onClose();
  }
}
