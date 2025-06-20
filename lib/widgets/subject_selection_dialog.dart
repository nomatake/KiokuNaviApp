import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/generated/assets.gen.dart';

// Dialog positioning constants
const double kTriangleTopPosition = 120.0;
const double kDialogTopPosition = 134.0;
const double kDialogHeight = 126.0;

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

  const SubjectSelectionDialog({
    super.key,
    this.onSubjectSelected,
  });

  static void show(BuildContext context,
      {Function(Subject)? onSubjectSelected}) {
    showDialog(
      context: context,
      barrierColor: kBarrierColor,
      builder: (_) => SubjectSelectionDialog(
        onSubjectSelected: onSubjectSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              // Triangle pointer (placed first so it appears behind the dialog)
              Positioned(
                top: kTriangleTopPosition,
                left: k4Double.wp + (k18Double.wp / 2) - kTriangleHalfWidth,
                child: const CustomPaint(
                  size: Size(kTriangleWidth, kTriangleHeight),
                  painter: TrianglePainter(),
                ),
              ),
              // Main dialog content
              Positioned(
                top: kDialogTopPosition,
                left: 0,
                right: 0,
                child: Container(
                  height: kDialogHeight,
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
                      horizontal: k4Double.wp,
                      vertical: k1Double.hp,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: Subject.values
                          .map((subject) => _SubjectOption(
                                subject: subject,
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

  const _SubjectOption({
    required this.subject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isComprehensive = subject == Subject.comprehensive;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: kIconSize,
                height: kIconSize,
                decoration: BoxDecoration(
                  border: isComprehensive
                      ? Border.all(
                          color: kComprehensiveBorderColor,
                          width: kIconBorderWidth,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(kIconBorderRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kIconInnerBorderRadius),
                  child: _getSubjectIcon(),
                ),
              ),
              const SizedBox(height: kIconTextSpacing),
              Text(
                subject.title,
                style: kSubjectTextStyle.copyWith(fontSize: k16Double.sp),
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
              width: kIconImageSize,
              height: kIconImageSize,
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
