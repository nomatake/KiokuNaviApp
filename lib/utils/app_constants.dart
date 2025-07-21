/// Semantic constants for the KiokuNaviApp
/// Replaces magic numbers with meaningful names for better maintainability
library;

class AppSpacing {
  /// Micro spacing values
  static const double none = 0.0;
  static const double xxxs = 1.0;
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  /// Common UI spacing patterns
  static const double cardPadding = 16.0;
  static const double formFieldSpacing = 12.0;
  static const double buttonSpacing = 10.0;
  static const double sectionSpacing = 24.0;
  static const double screenPadding = 16.0;
  static const double contentPadding = 20.0;
}

class AppBorderRadius {
  /// Border radius values
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double circular = 100.0;

  /// Common UI border radius patterns
  static const double button = 12.0;
  static const double card = 16.0;
  static const double input = 8.0;
  static const double dialog = 20.0;
}

class AppFontSize {
  /// Font size values
  static const double caption = 10.0;
  static const double small = 12.0;
  static const double body = 14.0;
  static const double title = 16.0;
  static const double heading = 18.0;
  static const double large = 20.0;
  static const double xl = 24.0;
  static const double xxl = 28.0;

  /// Common text patterns
  static const double formLabel = 12.0;
  static const double formInput = 14.0;
  static const double buttonText = 16.0;
  static const double cardTitle = 18.0;
}

class AppIconSize {
  /// Icon size values
  static const double xs = 12.0;
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;

  /// Common icon patterns
  static const double button = 20.0;
  static const double navigation = 24.0;
  static const double avatar = 40.0;
  static const double large = 48.0;
}

class AppButtonSize {
  /// Button dimension values
  static const double small = 40.0;
  static const double medium = 48.0;
  static const double large = 56.0;
  static const double xl = 64.0;

  /// Common button patterns
  static const double primary = 50.0;
  static const double secondary = 44.0;
  static const double icon = 40.0;
  static const double fab = 56.0;
}

class AppContainerSize {
  /// Container dimension values
  static const double avatar = 40.0;
  static const double smallCard = 80.0;
  static const double mediumCard = 100.0;
  static const double largeCard = 120.0;
  static const double notification = 150.0;
  static const double hero = 300.0;
}

class AppOpacity {
  /// Opacity values
  static const double transparent = 0.0;
  static const double subtle = 0.1;
  static const double light = 0.2;
  static const double medium = 0.5;
  static const double high = 0.7;
  static const double strong = 0.8;
  static const double opaque = 1.0;

  /// Common opacity patterns
  static const double disabled = 0.38;
  static const double overlay = 0.6;
  static const double shadow = 0.25;
}

class AppElevation {
  /// Elevation values
  static const double none = 0.0;
  static const double sm = 1.0;
  static const double md = 2.0;
  static const double lg = 4.0;
  static const double xl = 8.0;
  static const double xxl = 16.0;

  /// Common elevation patterns
  static const double card = 2.0;
  static const double button = 4.0;
  static const double dialog = 8.0;
  static const double appBar = 4.0;
}

class AppAnimationDuration {
  /// Animation duration values in milliseconds
  static const int fast = 150;
  static const int normal = 300;
  static const int slow = 500;
  static const int slower = 800;

  /// Common animation patterns
  static const int fade = 200;
  static const int slide = 300;
  static const int scale = 250;
  static const int pageTransition = 400;
}

/// Fractional values for responsive scaling
class AppFraction {
  /// Common fractional values
  static const double quarter = 0.25;
  static const double third = 0.33;
  static const double half = 0.5;
  static const double twoThirds = 0.67;
  static const double threeQuarters = 0.75;
  static const double full = 1.0;

  /// Screen-based fractions
  static const double screenWidth80 = 0.8;
  static const double screenWidth90 = 0.9;
  static const double screenHeight60 = 0.6;
  static const double screenHeight70 = 0.7;
}

/// Negative values for special cases
class AppNegativeSpacing {
  static const double xs = -2.0;
  static const double sm = -4.0;
  static const double md = -8.0;
  static const double lg = -12.0;
  static const double xl = -16.0;
}
