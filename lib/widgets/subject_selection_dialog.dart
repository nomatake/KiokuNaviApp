import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/utils/adaptive_sizes.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

// Dialog positioning constants
const double kTriangleTopPosition = 120.0;
const double kDialogTopPosition = 134.0;
const double kDialogHeight = 126.0;

// DEFAULT SPACING (now using adaptive values from AdaptiveSizes)
// This constant is kept for reference but actual values are:
// - Phone: -50px (dialog appears much higher, extreme overlap)
// - iPad mini: -12px (moderate connection)
// - iPad Pro: -10px (looser connection)
const double kMasterButtonDialogGap = -50.0; // Default for phones

// Triangle dimensions
const double kTriangleWidth = 30.0;
const double kTriangleHeight = 18.0;
const double kTriangleHalfWidth = kTriangleWidth / 2;

// Icon and spacing constants
const double kIconSize = 56.0;
const double kIconBorderRadius = 15.0;
const double kIconInnerBorderRadius = 12.0;
const double kIconBorderWidth = 3.0;
const double kIconImageSize = 40.0;

// Spacing constants
const double kIconTextSpacing = 6.0;
const double kHorizontalPadding = 4.0;
const double kLetterSpacing = 2.0;

// Shadow constants
const double kShadowOpacity = 0.1;
const double kShadowBlurRadius = 10.0;
const double kShadowOffsetY = 4.0;

// Barrier opacity
const double kBarrierOpacity = 0.5;

// Comprehensive icon background opacity
const double kComprehensiveIconBgOpacity = 0.1;

// Pre-calculated colors to avoid runtime calculations
const Color kComprehensiveIconBgColor =
    Color(0x1A2E1581); // 0.1 opacity pre-calculated
const Color kComprehensiveBorderColor = Color(0xFF1BAFF5);
const Color kTextColor = Color(0xFF424242);
const Color kShadowColor = Color(0x1A000000); // 0.1 opacity pre-calculated
const Color kBarrierColor = Color(0x80000000); // 0.5 opacity pre-calculated

// Pre-defined text style to avoid recreation
const TextStyle kSubjectTextStyle = TextStyle(
  fontFamily: 'Hiragino Sans',
  fontWeight: FontWeight.w700,
  fontSize: 16.0, // Will be scaled with sp extension
  color: kTextColor,
  letterSpacing: kLetterSpacing,
);

/// Subject options available for selection
enum Subject {
  comprehensive('総合', null),
  socialStudies('社会', 'japan_icon'),
  science('理科', 'science_icon'),
  japanese('国語', 'language_icon');

  final String title;
  final String? iconName;

  const Subject(this.title, this.iconName);
}

/// A dialog widget that displays subject selection options
class SubjectSelectionDialog extends StatelessWidget {
  final Function(Subject)? onSubjectSelected;
  final GlobalKey? buttonKey;

  const SubjectSelectionDialog({
    super.key,
    this.onSubjectSelected,
    this.buttonKey,
  });

  static void show(BuildContext context,
      {Function(Subject)? onSubjectSelected, GlobalKey? buttonKey}) {
    showDialog(
      context: context,
      barrierColor: kBarrierColor,
      builder: (_) => SubjectSelectionDialog(
        onSubjectSelected: onSubjectSelected,
        buttonKey: buttonKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get adaptive sizing
    final bool isTablet = AdaptiveSizes.isTablet(context);

    // Adaptive dialog dimensions from centralized config
    final double dialogHeight = AdaptiveSizes.getDialogHeight(context);
    final double iconSize = AdaptiveSizes.getDialogIconSize(context);
    final double iconImageSize = AdaptiveSizes.getDialogIconImageSize(context);

    // Calculate button position if buttonKey is provided
    double triangleLeftPosition = k4Double.wp +
        (AdaptiveSizes.getGreenButtonWidth(context) / 2) -
        kTriangleHalfWidth;
    double dialogTopPosition = kDialogTopPosition;

    if (buttonKey != null && buttonKey!.currentContext != null) {
      final renderObject = buttonKey!.currentContext!.findRenderObject();
      if (renderObject is RenderBox) {
        final buttonBox = renderObject;
        final buttonPosition = buttonBox.localToGlobal(Offset.zero);
        final buttonSize = buttonBox.size;

        // Debug print button information
        debugPrint('Button position: ${buttonPosition.dy}');
        debugPrint('Button height: ${buttonSize.height}');
        debugPrint('Button bottom: ${buttonPosition.dy + buttonSize.height}');

        // Position dialog based on adaptive gap
        final double buttonBottom = buttonPosition.dy + buttonSize.height;
        final double adaptiveGap = AdaptiveSizes.getDialogButtonGap(context);
        dialogTopPosition = buttonBottom + adaptiveGap;

        // Center triangle with button
        triangleLeftPosition =
            buttonPosition.dx + (buttonSize.width / 2) - kTriangleHalfWidth;
      }
    }

    // Calculate triangle position based on button position
    // Start with a default position
    double triangleTopPosition = dialogTopPosition - kTriangleHeight;

    // If we have button position, place triangle right at button bottom
    if (buttonKey != null && buttonKey!.currentContext != null) {
      final renderObject = buttonKey!.currentContext!.findRenderObject();
      if (renderObject is RenderBox) {
        final buttonBox = renderObject;
        final buttonPosition = buttonBox.localToGlobal(Offset.zero);
        final buttonSize = buttonBox.size;

        // Get adaptive gap for this device
        final double adaptiveGap = AdaptiveSizes.getDialogButtonGap(context);

        // Debug print for triangle positioning
        debugPrint('Adaptive gap: $adaptiveGap');
        debugPrint('Dialog top position: $dialogTopPosition');

        // Position triangle at the top edge of the dialog, slightly overlapping
        // This ensures it's always visible regardless of the gap
        triangleTopPosition =
            dialogTopPosition - kTriangleHeight + 3; // 3px overlap into dialog

        // Debug print triangle position
        debugPrint('Triangle top position: $triangleTopPosition');
        debugPrint('Triangle left position: $triangleLeftPosition');
      }
    }

    return GestureDetector(
      onTap: Get.back, // Close dialog when tapping outside
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () {}, // Prevent dialog from closing when tapping inside
          child: Stack(
            clipBehavior: Clip.none, // Allow triangle to overflow
            alignment: Alignment.topCenter,
            children: [
              // Main dialog content (placed first so triangle appears on top)
              Positioned(
                top: dialogTopPosition,
                left: isTablet ? -20 : 0, // Extend dialog width on tablets
                right: isTablet ? -20 : 0, // Extend dialog width on tablets
                child: Container(
                  height: dialogHeight,
                  margin: EdgeInsets.symmetric(
                    horizontal: isTablet
                        ? 20
                        : 0, // Compensate for negative positioning
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: kShadowColor,
                        blurRadius: kShadowBlurRadius,
                        offset: Offset(0, kShadowOffsetY),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet
                          ? k6Double.wp
                          : k4Double.wp, // More horizontal padding on tablets
                      vertical: isTablet
                          ? (AdaptiveSizes.isLandscape(context)
                              ? k2Double
                                  .hp // More padding in landscape with more height
                              : k0_5Double
                                  .hp) // Very minimal padding in portrait with reduced height
                          : k1Double.hp, // Original padding for phones
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: Subject.values
                          .map((subject) => _SubjectOption(
                                subject: subject,
                                iconSize: iconSize,
                                iconImageSize: iconImageSize,
                                isTablet: isTablet,
                                onTap: () {
                                  onSubjectSelected?.call(subject);
                                  Get.back();
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              // Triangle pointer (placed last so it appears on top)
              Positioned(
                top: triangleTopPosition,
                left: triangleLeftPosition,
                child: const CustomPaint(
                  size: Size(kTriangleWidth, kTriangleHeight),
                  painter: TrianglePainter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extracted subject option widget for better performance
class _SubjectOption extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;
  final double iconSize;
  final double iconImageSize;
  final bool isTablet;

  const _SubjectOption({
    required this.subject,
    required this.onTap,
    required this.iconSize,
    required this.iconImageSize,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final isComprehensive = subject == Subject.comprehensive;
    final double fontSize = AdaptiveSizes.getDialogTextSize(context);
    final double borderRadius = isTablet ? 20.0 : kIconBorderRadius;
    final double innerBorderRadius = isTablet ? 16.0 : kIconInnerBorderRadius;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 8.0 : kHorizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  border: isComprehensive
                      ? Border.all(
                          color: kComprehensiveBorderColor,
                          width: kIconBorderWidth,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(innerBorderRadius),
                  child: _getSubjectIcon(),
                ),
              ),
              SizedBox(
                height: isTablet
                    ? (AdaptiveSizes.isLandscape(context)
                        ? 12.0 // More spacing in landscape with taller dialog
                        : 4.0) // Minimal spacing in portrait with shorter dialog
                    : kIconTextSpacing,
              ),
              Text(
                subject.title,
                style: kSubjectTextStyle.copyWith(fontSize: fontSize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSubjectIcon() {
    switch (subject) {
      case Subject.comprehensive:
        return Container(
          color: kComprehensiveIconBgColor,
          child: Center(
            child: Assets.images.comprehensive.image(
              width: iconImageSize,
              height: iconImageSize,
              fit: BoxFit.contain,
            ),
          ),
        );
      case Subject.socialStudies:
        return Assets.images.japanIcon.image(fit: BoxFit.cover);
      case Subject.science:
        return Assets.images.scienceIcon.image(fit: BoxFit.cover);
      case Subject.japanese:
        return Assets.images.languageIcon.image(fit: BoxFit.cover);
    }
  }
}

/// Custom painter for the triangle pointer
class TrianglePainter extends CustomPainter {
  const TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
