import "dart:io";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:getwidget/getwidget.dart";
import "package:kioku_navi/utils/extensions.dart";
import "package:kioku_navi/utils/sizes.dart";

class CustomLoader {
  static void showLoader(BuildContext context, String? message) {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(76, 190, 190, 190),
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: k0Double,
          child: message == null || message.isEmpty
              ? _buildLoaderOnly()
              : _buildLoaderWithMessage(message),
        ),
      ),
    );
  }

  static Widget _buildLoaderOnly() {
    return GFLoader(
      type: Platform.isAndroid ? GFLoaderType.android : GFLoaderType.ios,
      size: GFSize.LARGE,
    );
  }

  static Widget _buildLoaderWithMessage(String message) {
    return Container(
      padding: EdgeInsets.all(k6Double.wp),
      margin: EdgeInsets.symmetric(horizontal: k10Double.wp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(k10Double),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GFLoader(
            type: Platform.isAndroid ? GFLoaderType.android : GFLoaderType.ios,
            size: GFSize.LARGE,
          ),
          SizedBox(height: k2_5Double.hp),
          Text(
            message,
            style: TextStyle(
              fontSize: k10Double.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  static void hideLoader() => Get.back(closeOverlays: true);
}
