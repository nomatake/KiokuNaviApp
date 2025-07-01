import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:kioku_navi/utils/constants.dart";
import "package:kioku_navi/utils/sizes.dart";

extension PercentSized on double {
  double get hp => (Get.height * (this / k100));
  double get wp => (Get.width * (this / k100));
}

extension ResponsiveText on double {
  double get sp {
    double width = Get.width;
    double divisor;
    if (width < 360) {
      // Small phones (e.g., iPhone SE)
      divisor = 2.75;
    } else if (width < 414) {
      // Regular phones (e.g., iPhone 12/13)
      divisor = 3.0;
    } else if (width < 480) {
      // Large phones (e.g., iPhone Pro Max)
      divisor = 3.5;
    } else if (width < 768) {
      // Small tablets (e.g., iPad Mini)
      divisor = 4;
    } else if (width < 1024) {
      // Regular tablets (e.g., iPad)
      divisor = 4.5;
    } else if (width < 1366) {
      // Large tablets / small laptops
      divisor = 5.0;
    } else {
      // Desktops
      divisor = 7.0;
    }
    return width / k100 * (this / divisor);
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final StringBuffer buffer = StringBuffer();
    if (hexString.length == k6 || hexString.length == k7) buffer.write("ff");
    buffer.write(hexString.replaceFirst("#", ""));
    return Color(int.parse(buffer.toString(), radix: k16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(k16).padLeft(k2, '0')}'
      '${red.toRadixString(k16).padLeft(k2, '0')}'
      '${green.toRadixString(k16).padLeft(k2, '0')}'
      '${blue.toRadixString(k16).padLeft(k2, '0')}';
}

extension StringCapitalization on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[k0].toUpperCase() + substring(k1).toLowerCase();
  }

  String decapitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[k0].toLowerCase() + substring(k1);
  }
}

extension GetArgumentsExtension on GetInterface {
  bool canGoBack({String key = kCanGoBack, bool defaultValue = true}) {
    return (arguments == null || arguments[key] == null)
        ? defaultValue
        : arguments[key];
  }
}

extension StringCasingExtension on String {
  String toCapitalized() {
    return length > k0
        ? "${this[k0].toUpperCase()}${substring(k1).toLowerCase()}"
        : kEmpty;
  }

  String toTitleCase() {
    return replaceAll(RegExp(" +"), " ")
        .split(" ")
        .map((String str) => str.toCapitalized())
        .join(" ");
  }
}
