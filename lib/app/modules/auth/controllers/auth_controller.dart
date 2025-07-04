import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/controllers/base_controller.dart';

class AuthController extends BaseController {
  /// Form key for the registration form in RegisterView. Used to validate and manage form state.
  final registerFormKey = GlobalKey<FormState>();
  final parentLoginFormKey = GlobalKey<FormState>();
  final studentLoginFormKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final dob = TextEditingController();
  final password = TextEditingController();

  /// Selected dates for the calendar picker (single date for DOB)
  RxList<DateTime?> selectedDates = <DateTime?>[].obs;

  /// Format date for display
  String formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  /// Handle date selection from calendar
  void onDateSelected(List<DateTime?> dates) {
    selectedDates.value = dates;
    if (dates.isNotEmpty && dates.first != null) {
      dob.text = formatDate(dates.first);
    }
  }

  void onRegister() {
    safeCall(() async {
      if (!registerFormKey.currentState!.validate()) {
        throw 'Please fill in all required fields correctly';
      }
      
      // TODO: Implement registration logic
    }, errorMessage: 'Registration failed. Please try again.');
  }

  void onLogin() {
    safeCall(() async {
      // TODO: Implement login logic
    }, errorMessage: 'Login failed. Please check your credentials.');
  }

  void onForgotPassword() {
    safeCall(() async {
      // TODO: Implement forgot password logic
    }, errorMessage: 'Password reset failed. Please try again.');
  }

  @override
  void onClose() {
    email.dispose();
    dob.dispose();
    password.dispose();
    super.onClose();
  }
}
