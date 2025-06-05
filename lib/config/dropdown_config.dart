import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

class DropdownConfig {
  static CustomDropdownDecoration get dropdownDecoration {
    return CustomDropdownDecoration(
      closedBorderRadius: BorderRadius.circular(k25Double),
      closedErrorBorderRadius: BorderRadius.circular(k25Double),
      closedBorder: Border.all(color: Colors.grey.shade300),
      closedErrorBorder:
          Border.all(color: Colors.red.shade900, width: k1_05Double),
      closedFillColor: Colors.grey.shade50,
      errorStyle: TextStyle(fontSize: k9Double.sp),
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
