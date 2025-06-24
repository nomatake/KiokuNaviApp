import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/dotted_background.dart';

/// A widget that creates an adaptive dotted background pattern.
///
/// This widget automatically calculates the optimal spacing and number of dots
/// to fill the available width from edge to edge, ensuring dots appear on both
/// left and right sides.
class AdaptiveDottedBackground extends StatelessWidget {
  /// The desired horizontal spacing between dots (used as a starting point)
  final double desiredHorizontalSpacing;

  /// The vertical spacing multiplier relative to horizontal spacing
  final double verticalSpacingMultiplier;

  /// The size of each dot
  final double dotSize;

  /// The color of the dots
  final Color dotColor;

  /// Maximum number of dots per row (useful for tablets)
  final int? maxDotsPerRow;

  /// Creates an adaptive dotted background widget.
  ///
  /// The widget will automatically calculate the exact spacing needed
  /// to ensure dots appear on both edges of the available width.
  const AdaptiveDottedBackground({
    super.key,
    this.desiredHorizontalSpacing = 45.0,
    this.verticalSpacingMultiplier = 1.1,
    this.dotSize = 10.0,
    this.dotColor = const Color.fromRGBO(71, 145, 219, 0.07),
    this.maxDotsPerRow,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate dots configuration to fill the available width uniformly
    final double availableWidth = Get.width - (k6Double.wp * 2);

    // Determine device type based on shortest side
    // Better detection for tablets including iPad mini
    final context = Get.context;
    if (context == null) {
      return DottedBackground(
        leftPadding: dotSize / 2,
        dotsPerRow: 8,
        horizontalSpacing: desiredHorizontalSpacing,
        verticalSpacing: desiredHorizontalSpacing * verticalSpacingMultiplier,
        dotSize: dotSize,
        dotColor: dotColor,
      );
    }

    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool isTablet = shortestSide >= 550;
    final bool isLargeTablet = shortestSide >= 768;

    // Adaptive dot size based on device type
    final double adaptiveDotSize;
    if (isLargeTablet) {
      adaptiveDotSize = dotSize * 1.5; // 15px for large tablets
    } else if (isTablet) {
      adaptiveDotSize = dotSize * 1.3; // 13px for regular tablets
    } else {
      adaptiveDotSize = dotSize; // 10px for phones
    }

    // Adaptive spacing based on device type
    final double adaptiveHorizontalSpacing;
    if (isLargeTablet) {
      adaptiveHorizontalSpacing =
          desiredHorizontalSpacing * 2.0; // 90px for large tablets
    } else if (isTablet) {
      adaptiveHorizontalSpacing =
          desiredHorizontalSpacing * 1.5; // 67.5px for regular tablets
    } else {
      adaptiveHorizontalSpacing = desiredHorizontalSpacing; // 45px for phones
    }

    // For tablets, we might want to limit the number of dots or use fixed spacing
    double horizontalSpacing;
    int targetDotsPerRow;
    double dotStartPadding;

    if (isTablet) {
      // For tablets, use fixed spacing and center the dot pattern
      horizontalSpacing = adaptiveHorizontalSpacing;
      targetDotsPerRow =
          ((availableWidth - adaptiveDotSize) / horizontalSpacing).floor() + 1;

      // Apply max dots per row limit if specified
      final int effectiveMaxDots = maxDotsPerRow ?? (isLargeTablet ? 15 : 12);
      if (targetDotsPerRow > effectiveMaxDots) {
        targetDotsPerRow = effectiveMaxDots;
      }

      // Calculate the actual width of the dot pattern
      final double patternWidth =
          (targetDotsPerRow - 1) * horizontalSpacing + adaptiveDotSize;

      // Center the pattern if it doesn't fill the entire width
      if (patternWidth < availableWidth) {
        dotStartPadding =
            (availableWidth - patternWidth) / 2 + adaptiveDotSize / 2;
      } else {
        // If pattern is wider, recalculate to fit edge to edge
        horizontalSpacing =
            (availableWidth - adaptiveDotSize) / (targetDotsPerRow - 1);
        dotStartPadding = adaptiveDotSize / 2;
      }
    } else {
      // For phones, fill edge to edge as before
      targetDotsPerRow =
          ((availableWidth - adaptiveDotSize) / adaptiveHorizontalSpacing)
                  .floor() +
              1;
      horizontalSpacing =
          (availableWidth - adaptiveDotSize) / (targetDotsPerRow - 1);
      dotStartPadding = adaptiveDotSize / 2;
    }

    // Calculate vertical spacing to match the horizontal pattern
    final double verticalSpacing =
        horizontalSpacing * verticalSpacingMultiplier;

    return DottedBackground(
      leftPadding: dotStartPadding,
      dotsPerRow: targetDotsPerRow,
      horizontalSpacing: horizontalSpacing,
      verticalSpacing: verticalSpacing,
      dotSize: adaptiveDotSize,
      dotColor: dotColor,
    );
  }
}
