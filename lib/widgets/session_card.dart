import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/sizes.dart';

class SessionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final bool showTrophy;
  final VoidCallback? onTap;

  const SessionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    this.showTrophy = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = progress >= k1Double;
    final media = MediaQuery.of(context);
    // Use screen width to scale sizes
    final width = media.size.width;

    // Improved scaling logic for better iPad support
    double scale;
    if (width <= k375Double) {
      // For small screens (iPhone SE, etc.), use the width directly
      scale = width / k375Double;
    } else if (width <= 428) {
      // For regular phones (iPhone 11-14 Pro Max), scale normally
      scale = width / k375Double;
    } else if (width <= 768) {
      // For small tablets and large phones in landscape, limit scaling
      scale = 1.2; // Cap at 1.2x for these devices
    } else {
      // For iPads and larger screens, use a fixed scale
      scale = 1.0; // Keep original size or even smaller
    }

    // Additional check: if the device is likely an iPad (aspect ratio check)
    final aspectRatio = media.size.width / media.size.height;
    if (aspectRatio < 0.75 || aspectRatio > 1.3) {
      // Likely a tablet in portrait or landscape
      scale = scale.clamp(0.8, 1.0); // Further limit scale for tablets
    }

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Detect if this is likely an iPad
          final isIPad =
              width > 768 || (aspectRatio < 0.75 || aspectRatio > 1.3);

          final cardPadding = EdgeInsets.symmetric(
            horizontal: k23Double * scale,
            vertical: isIPad
                ? k18Double * scale
                : k10Double * scale, // Increased vertical padding for iPad
          );
          final borderRadius = BorderRadius.circular(k12Double * scale);
          final trophySize = k40Double * scale;
          final trophyPadding = EdgeInsets.all(k2Double * scale);
          final progressBarHeight = k15Double * scale;
          final titleFontSize = k15Double * scale;
          final subtitleFontSize = k20Double * scale;

          return Container(
            // Remove fixed height, let content dictate height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
              border: Border.all(
                color: const Color(0xFFB0BEC5),
                width: k2Double * scale,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: k2Double * scale,
                  offset: Offset(k0Double, k1Double * scale),
                ),
                BoxShadow(
                  color: const Color(0xFFB0BEC5),
                  offset: Offset(k0Double, k3Double * scale),
                  blurRadius: k0Double,
                  spreadRadius: k0Double,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Yellow stripe pattern for completed sessions
                if (isCompleted)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: borderRadius,
                      child: CustomPaint(
                        painter: _StripePainter(),
                      ),
                    ),
                  ),
                Padding(
                  padding: cardPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Hiragino Sans',
                                fontWeight: FontWeight.w600,
                                fontSize: titleFontSize,
                                color: const Color(0xFF424242)
                                    .withOpacity(0.75),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                                height: isIPad ? k4Double * scale : k0Double),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontFamily: 'Hiragino Sans',
                                fontWeight: FontWeight.w700,
                                fontSize: subtitleFontSize,
                                color: const Color(0xFF424242),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                                height: isIPad
                                    ? k8Double * scale
                                    : k4Double *
                                        scale), // More spacing for iPad
                            SizedBox(
                              width: double.infinity,
                              child: SessionProgressBar(
                                progress: progress,
                                height: progressBarHeight,
                                scale: scale,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (showTrophy) ...[
                        SizedBox(width: k8Double * scale),
                        Container(
                          padding: trophyPadding,
                          child: Icon(
                            Icons.emoji_events_sharp,
                            color: isCompleted
                                ? const Color(0xFFFFA726)
                                : const Color(0xFFCFD8DC),
                            size: trophySize,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Custom progress bar for sessions
class SessionProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final double scale;

  const SessionProgressBar({
    super.key,
    required this.progress,
    required this.height,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFCFD8DC),
        borderRadius: BorderRadius.circular(k100Double * scale),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress.clamp(k0Double, k1Double),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(k100Double * scale),
              ),
            ),
          ),
          Positioned(
            left: k4Double * scale,
            top: k3Double * scale,
            right: k4Double * scale,
            child: Container(
              height: k4Double * scale,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(k100Double * scale),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Painter for yellow stripe pattern
class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5F100).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    const stripeWidth = k69Double;
    const spacing = k31Double;
    const totalWidth = stripeWidth + spacing;

    for (double x = k0Double; x < size.width + stripeWidth; x += totalWidth) {
      canvas.drawRect(
        Rect.fromLTWH(x, k0Double, stripeWidth, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
