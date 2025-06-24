import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/extensions.dart';

/// Centralized adaptive sizing utilities for responsive design across different devices
class AdaptiveSizes {
  // Private constructor to prevent instantiation
  AdaptiveSizes._();

  /// Device type detection thresholds
  static const double _tabletThreshold = 550.0;
  static const double _largeTabletThreshold = 768.0;

  /// Determines if the current device is a tablet based on shortest side
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= _tabletThreshold;
  }

  /// Determines if the current device is a large tablet (iPad Pro)
  static bool isLargeTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= _largeTabletThreshold;
  }

  /// Gets device type as an enum for cleaner code
  static DeviceType getDeviceType(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide >= _largeTabletThreshold) {
      return DeviceType.largeTablet;
    } else if (shortestSide >= _tabletThreshold) {
      return DeviceType.tablet;
    } else {
      return DeviceType.phone;
    }
  }

  /// Determines if the device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // ========== Course Node Sizes ==========

  /// Adaptive node size for course progress indicators
  static double getNodeSize(BuildContext context) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return landscape ? k12Double.wp : k14Double.wp; // Smaller in landscape
      case DeviceType.tablet:
        return landscape ? k13Double.wp : k15Double.wp; // Smaller in landscape
      case DeviceType.phone:
        return k18Double.wp; // 18% of width
    }
  }

  /// Progress indicator stroke width
  static double getProgressStrokeWidth(BuildContext context) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
      case DeviceType.tablet:
        return landscape ? 14.0 : 8.0; // Much thicker in landscape
      case DeviceType.phone:
        return 6.0; // Original thickness
    }
  }

  /// Padding between progress indicator and button
  static double getProgressPadding(BuildContext context, double nodeSize) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
      case DeviceType.tablet:
        return landscape
            ? nodeSize * 0.012 // 1.2% in landscape (even more reduced)
            : nodeSize * 0.025; // 2.5% in portrait
      case DeviceType.phone:
        return nodeSize * 0.03; // 3% of node size
    }
  }

  /// Vertical spacing between course nodes
  static double getNodeVerticalSpacing(BuildContext context) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
      case DeviceType.tablet:
        return landscape
            ? k22Double.hp
            : k12Double.hp; // More spacing in landscape
      case DeviceType.phone:
        return k12Double.hp; // Original spacing
    }
  }

  // ========== Green Button Sizes ==========

  /// Subject selection button width
  static double getGreenButtonWidth(BuildContext context) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return landscape ? k9Double.wp : k12Double.wp; // Reduced from 14%
      case DeviceType.tablet:
        return landscape ? k10Double.wp : k13Double.wp; // Reduced from 15%
      case DeviceType.phone:
        return landscape ? k14Double.wp : k16Double.wp; // Reduced from 18%
    }
  }

  /// Subject selection button height
  static double getGreenButtonHeight(BuildContext context) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return landscape ? k10Double.wp : k13Double.wp; // Reduced from 15%
      case DeviceType.tablet:
        return landscape ? k11Double.wp : k14Double.wp; // Reduced from 16%
      case DeviceType.phone:
        return landscape ? k15Double.wp : k17Double.wp; // Reduced from 19%
    }
  }

  /// Icon size inside green button
  static double getGreenButtonIconSize(BuildContext context) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return landscape ? k6Double.wp : k8Double.wp; // Reduced from 9%
      case DeviceType.tablet:
        return landscape ? k7Double.wp : k9Double.wp; // Reduced from 10%
      case DeviceType.phone:
        return landscape ? k10Double.wp : k11Double.wp; // Reduced from 13%
    }
  }

  /// Separator height between green buttons
  static double getGreenButtonSeparatorHeight(BuildContext context) {
    final bool landscape = isLandscape(context);

    if (isTablet(context)) {
      return landscape ? k6Double.wp : k10Double.wp; // Smaller in landscape
    } else {
      return landscape ? k8Double.wp : k12Double.wp; // Smaller in landscape
    }
  }

  // ========== App Bar Sizes ==========

  /// App bar extra height for tablets
  static double getAppBarExtraHeight(BuildContext context) {
    if (isTablet(context)) {
      return isLandscape(context) ? 40.0 : 30.0; // More height for tablets
    }
    return 0.0;
  }

  /// App bar top padding
  static double getAppBarTopPadding(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return isLandscape ? 24.0 : 20.0; // Increased padding
      case DeviceType.tablet:
        return isLandscape ? 20.0 : 16.0; // Increased padding
      case DeviceType.phone:
        return 0.0; // SafeArea handles it
    }
  }

  /// App bar bottom padding
  static double getAppBarBottomPadding(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    if (isTablet(context)) {
      return isLandscape ? 20.0 : 16.0; // Increased padding
    }
    return 0.0;
  }

  /// App bar icon size
  static double getAppBarIconSize(BuildContext context) {
    return isTablet(context) ? k5Double.wp : k6Double.wp;
  }

  /// App bar text size
  static double getAppBarFontSize(BuildContext context) {
    return isTablet(context) ? k14Double.sp : k16Double.sp;
  }

  // ========== Dotted Background ==========

  /// Horizontal spacing multiplier for dots
  static double getDotSpacingMultiplier(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return 1.33; // 60px * 1.33 = ~80px spacing
      case DeviceType.tablet:
        return 1.17; // 60px * 1.17 = ~70px spacing
      case DeviceType.phone:
        return 0.75; // 60px * 0.75 = 45px spacing (original)
    }
  }

  /// Dot size
  static double getDotSize(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return 16.0; // Larger dots for large tablets
      case DeviceType.tablet:
        return 14.0; // Medium dots for tablets
      case DeviceType.phone:
        return 10.0; // Original smaller dots for phones
    }
  }

  /// Maximum dots per row for tablets
  static int? getMaxDotsPerRow(BuildContext context) {
    return null; // No limit for any device
  }

  // ========== Rounded Button (Progress Node) ==========

  /// Shadow offset for rounded buttons
  static double getRoundedButtonShadowOffset(
      BuildContext context, double size) {
    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return size <= 60 ? -4.0 : -8.0; // More shadow for iPad Pro
      case DeviceType.tablet:
        return size <= 60 ? -5.0 : -10.0; // Even more shadow for iPad mini
      case DeviceType.phone:
        return -6.0; // Original shadow for phones
    }
  }

  // ========== Subject Selection Dialog ==========

  /// Dialog height
  static double getDialogHeight(BuildContext context) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return landscape
            ? 200.0 // Reduced from 240.0 for more compact landscape view
            : 180.0; // Reduced from 220.0 for compact portrait view
      case DeviceType.tablet:
        return landscape
            ? 180.0 // Reduced from 220.0 for more compact landscape view
            : 150.0; // Reduced from 170.0 for compact portrait view
      case DeviceType.phone:
        return landscape
            ? 140.0 // Reduced from 150.0 for more compact landscape view
            : 126.0; // Original size for phones in portrait
    }
  }

  /// Dialog icon size
  static double getDialogIconSize(BuildContext context) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return landscape ? 85.0 : 75.0; // Reduced from 100.0 for landscape
      case DeviceType.tablet:
        return landscape ? 75.0 : 65.0; // Reduced from 90.0 for landscape
      case DeviceType.phone:
        return landscape ? 60.0 : 56.0; // Reduced from 65.0 for landscape
    }
  }

  /// Dialog icon image size (inside the icon container)
  static double getDialogIconImageSize(BuildContext context) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return landscape ? 62.0 : 54.0; // Reduced from 72.0 for landscape
      case DeviceType.tablet:
        return landscape ? 54.0 : 46.0; // Reduced from 64.0 for landscape
      case DeviceType.phone:
        return landscape ? 42.0 : 40.0; // Reduced from 46.0 for landscape
    }
  }

  /// Dialog text size
  static double getDialogTextSize(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return k18Double.sp; // Reduced from k22
      case DeviceType.tablet:
        return k17Double.sp; // Reduced from k20
      case DeviceType.phone:
        return k16Double.sp; // Original size
    }
  }

  /// Gap between button and dialog
  static double getDialogButtonGap(BuildContext context) {
    final bool landscape = isLandscape(context);

    switch (getDeviceType(context)) {
      case DeviceType.largeTablet:
        return landscape
            ? -20.0 // More overlap to ensure triangle is visible
            : -25.0; // More overlap in portrait to remove the gap
      case DeviceType.tablet:
        return landscape
            ? -20.0 // More overlap to ensure triangle is visible
            : -20.0; // More overlap to remove the gap
      case DeviceType.phone:
        return landscape
            ? -30.0 // More overlap in landscape
            : -50.0; // Extreme overlap to bring dialog much higher on phones in portrait
    }
  }

  // ========== Debug Helpers ==========

  /// Debug log device info
  static void logDeviceInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    final deviceType = getDeviceType(context);
    final orientation = MediaQuery.of(context).orientation;

    debugPrint('AdaptiveSizes Debug:');
    debugPrint('  Screen: ${size.width} x ${size.height}');
    debugPrint('  Shortest side: $shortestSide');
    debugPrint('  Device type: $deviceType');
    debugPrint('  Orientation: $orientation');
  }
}

/// Device type enumeration for cleaner code
enum DeviceType {
  phone,
  tablet,
  largeTablet,
}
