/// Responsive utility for optimizing MediaQuery usage in KiokuNaviApp
/// Reduces redundant MediaQuery.of(context) calls and provides consistent screen information
library;

import 'package:flutter/material.dart';

/// Screen information calculated once and reused throughout widget tree
class ScreenInfo {
  /// Screen width in logical pixels
  final double width;
  
  /// Screen height in logical pixels
  final double height;
  
  /// Current screen orientation
  final Orientation orientation;
  
  /// Device pixel ratio for the current screen
  final double devicePixelRatio;
  
  /// Text scaler for accessibility
  final TextScaler textScaler;
  
  /// Calculated responsive scale factor based on screen width
  final double responsiveScale;
  
  /// Whether the device is likely an iPad or tablet
  final bool isTablet;
  
  /// Whether the device is a small phone
  final bool isSmallPhone;
  
  /// Whether the device is a large phone
  final bool isLargePhone;

  const ScreenInfo._({
    required this.width,
    required this.height,
    required this.orientation,
    required this.devicePixelRatio,
    required this.textScaler,
    required this.responsiveScale,
    required this.isTablet,
    required this.isSmallPhone,
    required this.isLargePhone,
  });

  /// Creates ScreenInfo from MediaQueryData
  factory ScreenInfo.from(MediaQueryData mediaQuery) {
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final aspectRatio = width / height;
    
    // Calculate responsive scale based on reference width (375px - iPhone)
    double responsiveScale;
    if (width <= 375) {
      responsiveScale = width / 375;
    } else if (width <= 428) {
      responsiveScale = width / 375;
    } else if (width <= 768) {
      responsiveScale = 1.2; // Cap for small tablets
    } else {
      responsiveScale = 1.0; // Fixed scale for iPads
    }
    
    // Additional tablet detection using aspect ratio
    if (aspectRatio < 0.75 || aspectRatio > 1.3) {
      responsiveScale = responsiveScale.clamp(0.8, 1.0);
    }
    
    // Device type detection
    final isTablet = width > 768 || (aspectRatio < 0.75 || aspectRatio > 1.3);
    final isSmallPhone = width <= 375;
    final isLargePhone = width > 375 && width <= 428;
    
    return ScreenInfo._(
      width: width,
      height: height,
      orientation: mediaQuery.orientation,
      devicePixelRatio: mediaQuery.devicePixelRatio,
      textScaler: mediaQuery.textScaler,
      responsiveScale: responsiveScale,
      isTablet: isTablet,
      isSmallPhone: isSmallPhone,
      isLargePhone: isLargePhone,
    );
  }

  /// Creates ScreenInfo directly from BuildContext
  factory ScreenInfo.fromContext(BuildContext context) {
    return ScreenInfo.from(MediaQuery.of(context));
  }

  /// Whether device is in landscape mode
  bool get isLandscape => orientation == Orientation.landscape;
  
  /// Whether device is in portrait mode
  bool get isPortrait => orientation == Orientation.portrait;
  
  /// Whether device has small screen width
  bool get isSmallScreen => width <= 428;
  
  /// Whether device has medium screen width
  bool get isMediumScreen => width > 428 && width <= 768;
  
  /// Whether device has large screen width
  bool get isLargeScreen => width > 768;
}

/// Widget builder function that receives screen information
typedef ResponsiveBuilder = Widget Function(BuildContext context, ScreenInfo screenInfo);

/// Wrapper widget that optimizes MediaQuery usage by calculating screen info once
class ResponsiveWrapper extends StatelessWidget {
  /// Builder function that receives calculated screen information
  final ResponsiveBuilder builder;
  
  /// Creates a responsive wrapper that provides optimized screen information
  const ResponsiveWrapper({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final screenInfo = ScreenInfo.fromContext(context);
    return builder(context, screenInfo);
  }
}

/// Extension on BuildContext for convenient access to screen information
extension ResponsiveContext on BuildContext {
  /// Get screen information for the current context
  ScreenInfo get screenInfo => ScreenInfo.fromContext(this);
  
  /// Quick access to screen width
  double get screenWidth => MediaQuery.of(this).size.width;
  
  /// Quick access to screen height
  double get screenHeight => MediaQuery.of(this).size.height;
  
  /// Quick access to responsive scale
  double get responsiveScale => screenInfo.responsiveScale;
  
  /// Whether current device is a tablet
  bool get isTablet => screenInfo.isTablet;
  
  /// Whether current device is a small phone
  bool get isSmallPhone => screenInfo.isSmallPhone;
  
  /// Whether current device is a large phone
  bool get isLargePhone => screenInfo.isLargePhone;
}

/// Responsive value utility for different screen sizes
class ResponsiveValue<T> {
  /// Value for small screens (≤ 428px)
  final T small;
  
  /// Value for medium screens (429-768px)
  final T? medium;
  
  /// Value for large screens (> 768px)
  final T? large;
  
  /// Creates a responsive value configuration
  const ResponsiveValue({
    required this.small,
    this.medium,
    this.large,
  });
  
  /// Gets the appropriate value for the given screen info
  T getValue(ScreenInfo screenInfo) {
    if (screenInfo.isLargeScreen && large != null) {
      return large!;
    } else if (screenInfo.isMediumScreen && medium != null) {
      return medium!;
    } else {
      return small;
    }
  }
  
  /// Gets the appropriate value for the given context
  T getValueForContext(BuildContext context) {
    return getValue(context.screenInfo);
  }
}

/// Utility class for common responsive patterns
class ResponsivePatterns {
  /// Common button height pattern
  static ResponsiveValue<double> buttonHeight = const ResponsiveValue(
    small: 48.0,
    medium: 56.0,
    large: 64.0,
  );
  
  /// Common font size pattern
  static ResponsiveValue<double> bodyFontSize = const ResponsiveValue(
    small: 12.0,
    medium: 14.0,
    large: 16.0,
  );
  
  /// Common padding pattern
  static ResponsiveValue<double> contentPadding = const ResponsiveValue(
    small: 16.0,
    medium: 20.0,
    large: 24.0,
  );
  
  /// Bottom navigation bar height pattern
  static ResponsiveValue<double> bottomNavHeight = const ResponsiveValue(
    small: 75.0,
    medium: 85.0,
    large: 95.0,
  );
  
  /// Caption font size pattern
  static ResponsiveValue<double> captionFontSize = const ResponsiveValue(
    small: 10.0,
    medium: 12.0,
    large: 14.0,
  );
}