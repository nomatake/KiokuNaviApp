import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/app_constants.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

/// Configuration class for CustomDropdown styling throughout the app
class AppConfig {
  /// Returns the standardized decoration for CustomDropdown widgets
  static CustomDropdownDecoration get customDropdownDecoration {
    return CustomDropdownDecoration(
      closedBorderRadius: BorderRadius.circular(AppBorderRadius.md),
      closedErrorBorderRadius: BorderRadius.circular(AppBorderRadius.md),
      closedBorder: Border.all(color: Colors.grey.shade300),
      closedErrorBorder:
          Border.all(color: Colors.red.shade900, width: 2.0),
      closedFillColor: Colors.grey.shade50,
      errorStyle: TextStyle(
        fontSize: AppFontSize.caption.sp,
        color: Colors.red.shade900,
      ),
      hintStyle: TextStyle(
        fontSize: k11Double.sp,
        color: Colors.grey.shade400,
        fontWeight: FontWeight.normal,
      ),
      listItemStyle:
          TextStyle(fontSize: k11Double.sp, fontWeight: FontWeight.normal),
      headerStyle:
          TextStyle(fontSize: k11Double.sp, fontWeight: FontWeight.normal),
      closedSuffixIcon: Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
        size: k22Double.sp,
      ),
      expandedSuffixIcon: Icon(
        Icons.arrow_drop_up,
        color: Colors.black,
        size: k22Double.sp,
      ),
    );
  }
}
