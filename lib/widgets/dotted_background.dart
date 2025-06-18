import 'package:flutter/material.dart';

/// A widget that creates a dotted background pattern.
///
/// This widget generates a grid of small circular dots that can be used
/// as a background pattern. The dots are positioned in a regular grid
/// with customizable spacing, size, and color.
class DottedBackground extends StatelessWidget {
  /// Color of the dots
  final Color dotColor;

  /// Size of each dot (diameter)
  final double dotSize;

  /// Horizontal spacing between dots
  final double horizontalSpacing;

  /// Vertical spacing between dots
  final double verticalSpacing;

  /// Number of dots per row
  final int dotsPerRow;

  /// Left padding for the first dot
  final double leftPadding;

  /// Creates a dotted background widget.
  ///
  /// The default values match the Figma design:
  /// - Light blue dots with 7% opacity
  /// - 10px dot size
  /// - 55px horizontal spacing
  /// - 60px vertical spacing
  /// - 8 dots per row
  /// - 20px left padding (reduced from center alignment)
  const DottedBackground({
    super.key,
    this.dotColor = const Color.fromRGBO(71, 145, 219, 0.07),
    this.dotSize = 10.0,
    this.horizontalSpacing = 55.0,
    this.verticalSpacing = 60.0,
    this.dotsPerRow = 8,
    this.leftPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBackgroundPainter(
        dotColor: dotColor,
        dotSize: dotSize,
        horizontalSpacing: horizontalSpacing,
        verticalSpacing: verticalSpacing,
        dotsPerRow: dotsPerRow,
        leftPadding: leftPadding,
      ),
      child: const SizedBox.expand(),
    );
  }
}

/// Custom painter that draws the dotted pattern.
class _DottedBackgroundPainter extends CustomPainter {
  final Color dotColor;
  final double dotSize;
  final double horizontalSpacing;
  final double verticalSpacing;
  final int dotsPerRow;
  final double leftPadding;

  _DottedBackgroundPainter({
    required this.dotColor,
    required this.dotSize,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.dotsPerRow,
    required this.leftPadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final dotRadius = dotSize / 2;

    // Calculate how many rows we need to fill the entire height
    final totalRows = (size.height / verticalSpacing).ceil() + 1;

    // Start dots from the specified left padding
    final startX = leftPadding;

    for (int row = 0; row < totalRows; row++) {
      final y = row * verticalSpacing;

      // Skip if this row is below the visible area
      if (y - dotRadius > size.height) break;

      for (int col = 0; col < dotsPerRow; col++) {
        final x = startX + (col * horizontalSpacing);

        // Skip if this dot is outside the visible area
        if (x - dotRadius > size.width || x + dotRadius < 0) continue;

        canvas.drawCircle(
          Offset(x, y),
          dotRadius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _DottedBackgroundPainter ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.dotSize != dotSize ||
        oldDelegate.horizontalSpacing != horizontalSpacing ||
        oldDelegate.verticalSpacing != verticalSpacing ||
        oldDelegate.dotsPerRow != dotsPerRow ||
        oldDelegate.leftPadding != leftPadding;
  }
}
