import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

class CustomTooltip extends StatelessWidget {
  final Widget child;
  final String message;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? arrowColor;
  final double arrowWidth;
  final double arrowHeight;
  final bool showShadow;
  final double? maxWidth;
  final double spacing;

  const CustomTooltip({
    super.key,
    required this.child,
    required this.message,
    this.textStyle,
    this.padding,
    this.margin,
    this.borderRadius = 15,
    this.borderWidth = 2,
    this.borderColor = const Color(0xFFE5E5E5),
    this.backgroundColor = Colors.white,
    this.arrowColor,
    this.arrowWidth = 28.22,
    this.arrowHeight = 11.04,
    this.showShadow = false,
    this.maxWidth,
    this.spacing = 16,
  });

  Color get _backgroundColor => backgroundColor ?? const Color(0xFFFBFCEA);
  Color get _borderColor => borderColor ?? const Color(0xFFD8E82F);
  Color get _arrowColor => arrowColor ?? _backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth ?? Get.width * 0.8,
              ),
              margin: margin,
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: _borderColor, width: borderWidth),
                boxShadow: showShadow
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Padding(
                padding: padding ??
                    EdgeInsets.symmetric(
                      horizontal: k20Double,
                      vertical: k15Double,
                    ),
                child: Text(
                  message,
                  style: textStyle ??
                      TextStyle(
                        fontFamily: 'Hiragino Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: k14Double.sp,
                        color: const Color(0xFF4B4B4B),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: -arrowHeight + borderWidth,
              child: CustomPaint(
                size: Size(arrowWidth, arrowHeight),
                painter: _ArrowPainter(
                  color: _arrowColor,
                  borderColor: _borderColor,
                  borderWidth: borderWidth,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        child,
      ],
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;

  const _ArrowPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    final borderPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
