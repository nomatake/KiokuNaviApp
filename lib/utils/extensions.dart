import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:kioku_navi/utils/constants.dart";
import "package:kioku_navi/utils/sizes.dart";

extension PercentSized on double {
  double get hp => (Get.height * (this / k100));
  double get wp => (Get.width * (this / k100));
}

extension ResponsiveText on double {
  double get sp => Get.width / k100 * (this / k3);
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
