import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/adaptive_sizes.dart';
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
    this.desiredHorizontalSpacing = 60.0, // Increased from 45.0
    this.verticalSpacingMultiplier = 1.1,
    this.dotSize = 16.0, // Increased from 10.0
    this.dotColor = const Color.fromRGBO(71, 145, 219, 0.07),
    this.maxDotsPerRow,
  });

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the current width - this will update on orientation change
    final double screenWidth = MediaQuery.of(context).size.width;
    // Calculate padding based on current screen width
    final double padding = screenWidth * 0.06; // 6% of screen width
    final double availableWidth = screenWidth - (padding * 2);

    // Get adaptive sizes from centralized configuration
    final double adaptiveDotSize = AdaptiveSizes.getDotSize(context);
    final double spacingMultiplier =
        AdaptiveSizes.getDotSpacingMultiplier(context);
    final double adaptiveHorizontalSpacing =
        desiredHorizontalSpacing * spacingMultiplier;

    // Simple calculation to fill edge to edge
    final int targetDotsPerRow =
        ((availableWidth - adaptiveDotSize) / adaptiveHorizontalSpacing)
                .floor() +
            1;
    final double horizontalSpacing =
        (availableWidth - adaptiveDotSize) / (targetDotsPerRow - 1);
    final double dotStartPadding = adaptiveDotSize / 2;

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
