import 'package:flutter/material.dart';

class CustomTooltip extends StatelessWidget {
  final Widget child;
  final String message;
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final Color arrowColor;
  final double arrowWidth;
  final double arrowHeight;
  final bool showShadow;

  const CustomTooltip({
    super.key,
    required this.child,
    required this.message,
    this.width = 230,
    this.height = 75.11,
    this.margin,
    this.borderRadius = 15,
    this.borderWidth = 3,
    this.borderColor = const Color(0xFFE5E5E5),
    this.backgroundColor = Colors.white,
    this.arrowColor = Colors.white,
    this.arrowWidth = 28.22,
    this.arrowHeight = 11.04,
    this.showShadow = false,
  });

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
              width: width,
              height: height,
              margin: margin,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: borderColor, width: borderWidth),
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
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Hiragino Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Color(0xFF4B4B4B),
                  letterSpacing: -0.36,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: height - 3),
                child: CustomPaint(
                  size: Size(arrowWidth, arrowHeight),
                  painter: _ArrowPainter(
                    color: arrowColor,
                    borderColor: borderColor,
                    borderWidth: borderWidth,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
