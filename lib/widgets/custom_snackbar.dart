import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

/// Status enum for different snackbar types
enum Status {
  SUCCESS,
  ERROR,
  INFO,
}

/// Custom snackbar utility class
class CustomSnackbar {
  /// Show custom snackbar with specified status
  static void show({
    required String title,
    required String message,
    Status status = Status.SUCCESS,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (status) {
      case Status.SUCCESS:
        backgroundColor = Colors.green;
        icon = Icons.check_circle_rounded;
        break;
      case Status.ERROR:
        backgroundColor = Colors.red.shade400;
        icon = Icons.error;
        break;
      case Status.INFO:
        backgroundColor = Colors.blue.shade400;
        icon = Icons.info;
        break;
    }

    Get.snackbar(
      kEmpty,
      kEmpty,
      titleText: Text(
        title.toTitleCase(),
        style: TextStyle(
          fontSize: k10Double.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        message.toTitleCase(),
        style: TextStyle(
          fontSize: k9Double.sp,
          color: Colors.white,
        ),
      ),
      duration: const Duration(milliseconds: 2000),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      shouldIconPulse: false,
      margin: EdgeInsets.only(
        bottom: k16Double,
        left: k10Double,
        right: k10Double,
      ),
      boxShadows: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withAlpha((k255 * k0_25Double).round()),
          spreadRadius: k1Double,
          blurRadius: k5Double,
          offset: const Offset(k0Double, k3Double),
        ),
      ],
      mainButton: TextButton(
        onPressed: null,
        child: Icon(
          icon,
          color: Colors.white,
          size: k16Double.sp,
        ),
      ),
      instantInit: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  /// Convenience method for success snackbar
  static void showSuccess({
    required String title,
    required String message,
  }) {
    show(
      title: title,
      message: message,
      status: Status.SUCCESS,
    );
  }

  /// Convenience method for error snackbar
  static void showError({
    required String title,
    required String message,
  }) {
    show(
      title: title,
      message: message,
      status: Status.ERROR,
    );
  }

  /// Convenience method for info snackbar
  static void showInfo({
    required String title,
    required String message,
  }) {
    show(
      title: title,
      message: message,
      status: Status.INFO,
    );
  }
}

/// Legacy function for backward compatibility
void customSnackBar({
  required String title,
  required String message,
  Status status = Status.SUCCESS,
}) {
  CustomSnackbar.show(
    title: title,
    message: message,
    status: status,
  );
}
