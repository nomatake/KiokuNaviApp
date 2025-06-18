import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'dart:math';

class CourseSectionWidget extends StatelessWidget {
  final String title;
  final bool
      isAlignedRight; // true = dolphin on right (< pattern), false = dolphin on left (> pattern)
  final int totalDots;
  final int completedDots;
  final bool showDolphin;
  final int dolphinCount; // NEW: number of dolphins to show
  final VoidCallback? onTap;

  const CourseSectionWidget({
    super.key,
    required this.title,
    required this.isAlignedRight,
    this.totalDots = 8,
    this.completedDots = 0,
    this.showDolphin = false,
    this.dolphinCount = 1, // default to 1 dolphin
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int minNodes = 6;
    final int nodeCount = totalDots < minNodes ? minNodes : totalDots;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            _buildSectionHeader(),
            _buildProgressSectionWithNodeCount(nodeCount),
            SizedBox(height: k6Double.hp), // space below progress section
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2,
            color: const Color(0xFFE0E0E0),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: k4Double.wp),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Hiragino Sans',
              fontWeight: FontWeight.w600,
              fontSize: k18Double.sp,
              color: const Color(0xFF4BA0EA),
              letterSpacing: -0.36,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 2,
            color: const Color(0xFFE0E0E0),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSectionWithNodeCount(int nodeCount) {
    // Calculate height: topPadding + (nodeCount-1)*spacingY + nodeSize
    final double topPadding = k6Double.hp;
    final double spacingY = k10Double.hp;
    final double nodeSize = k18Double.wp;
    final double height = topPadding + (nodeCount - 1) * spacingY + nodeSize;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          _buildProgressIconsWithNodeCount(nodeCount),
          if (showDolphin) ..._buildMultipleDolphins(nodeCount),
        ],
      ),
    );
  }

  Widget _buildProgressIconsWithNodeCount(int nodeCount) {
    // Use same height as above for perfect fit
    final double topPadding = k6Double.hp;
    final double spacingY = k10Double.hp;
    final double nodeSize = k18Double.wp;
    final double height = topPadding + (nodeCount - 1) * spacingY + nodeSize;
    return SizedBox(
      height: height,
      child: Stack(
        children: _buildGreaterThanPatternWithNodeCount(nodeCount),
      ),
    );
  }

  List<Widget> _buildGreaterThanPatternWithNodeCount(int nodeCount) {
    List<Widget> icons = [];
    const int nodesPerZigZag = 3;
    final double spacingX = k16Double.wp;
    final double spacingY = k10Double.hp;
    final double centerX = Get.width / 2 - k18Double.wp / 2;
    final double topPadding = k6Double.hp;

    double x = centerX;
    bool isZig = isAlignedRight;

    for (int i = 0; i < nodeCount; i++) {
      int posInGroup = i % nodesPerZigZag;
      if (i == 0) {
        x = centerX;
      } else if (posInGroup == 0) {
        // Flip direction every 3 nodes, continue from last x
        isZig = !isZig;
        x = x + (isZig ? spacingX : -spacingX) * 0.8;
      } else {
        x = x + (isZig ? spacingX : -spacingX) * 0.8;
      }
      double y = topPadding + i * spacingY;
      final isCompleted = i < completedDots;
      final isActive = i == completedDots;

      icons.add(
        Positioned(
          left: x,
          top: y,
          child: _buildProgressIcon(isCompleted, isActive),
        ),
      );
    }
    return icons;
  }

  Widget _buildProgressIcon(bool isCompleted, bool isActive) {
    return SizedBox(
      width: k18Double.wp,
      height: k18Double.wp,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: k18Double.wp,
            height: k18Double.wp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? const Color(0xFF4791DB)
                  : const Color(0xFFE0E0E0),
              boxShadow: [
                BoxShadow(
                  color: isCompleted
                      ? const Color(0xFF1976D2)
                      : const Color(0xFFB7B7B7),
                  offset: const Offset(0, -2),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          Container(
            width: k12Double.wp,
            height: k12Double.wp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: _buildInnerIcon(isCompleted, isActive),
            ),
          ),
          if (isActive)
            SizedBox(
              width: k16Double.wp,
              height: k16Double.wp,
              child: CircularProgressIndicator(
                value: completedDots / totalDots,
                strokeWidth: 3,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF4BA0EA)),
                backgroundColor: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInnerIcon(bool isCompleted, bool isActive) {
    if (isCompleted) {
      return Icon(
        Icons.check,
        color: Colors.white,
        size: k8Double.wp,
      );
    } else if (isActive) {
      return Container(
        width: k10Double.wp,
        height: k10Double.wp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF4BA0EA),
        ),
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: k6Double.wp,
        ),
      );
    } else {
      return Icon(
        Icons.lock_outline,
        color: const Color(0xFFB7B7B7),
        size: k8Double.wp,
      );
    }
  }

  List<Widget> _buildMultipleDolphins(int nodeCount) {
    // Place dolphins next to the 3rd node (index 2) in each group of 3, up to dolphinCount
    const int nodesPerZigZag = 3;
    final double spacingX = k16Double.wp;
    final double spacingY = k10Double.hp;
    final double centerX = Get.width / 2 - k18Double.wp / 2;
    final double topPadding = k6Double.hp;
    final double nodeSize = k18Double.wp; // Use the node's width for offset
    final double dolphinSize = k28Double.wp;
    final double margin = k10Double.wp; // increased margin from the edge
    List<Widget> dolphins = [];
    int maxDolphins = (nodeCount / nodesPerZigZag).floor();
    int count = dolphinCount < maxDolphins ? dolphinCount : maxDolphins;
    double x = centerX;
    bool isZig = isAlignedRight;
    int dolphinPlaced = 0;
    for (int i = 0; i < nodeCount && dolphinPlaced < count; i++) {
      int posInGroup = i % nodesPerZigZag;
      if (i == 0) {
        x = centerX;
      } else if (posInGroup == 0) {
        isZig = !isZig;
        x = x + (isZig ? spacingX : -spacingX) * 0.8;
      } else {
        x = x + (isZig ? spacingX : -spacingX) * 0.8;
      }
      if (posInGroup == 2) {
        double y = topPadding + i * spacingY + (nodeSize - dolphinSize) / 2;
        // Place dolphin on the opposite side of the node (relative to center)
        double dolphinLeft =
            x < centerX ? Get.width - dolphinSize - margin : margin;
        dolphins.add(
          Positioned(
            left: dolphinLeft,
            top: y,
            child: SizedBox(
              width: k28Double.wp, // make dolphin bigger
              height: k28Double.wp,
              child: isAlignedRight
                  ? Assets.images.logo.image(
                      fit: BoxFit.contain,
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: Assets.images.logo.image(
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ),
        );
        dolphinPlaced++;
      }
    }
    return dolphins;
  }
}

class CourseSection {
  final String title;
  final bool isAlignedRight;
  final int totalDots;
  final int completedDots;
  final bool showDolphin;
  final String? subjectIcon;

  CourseSection({
    required this.title,
    required this.isAlignedRight,
    this.totalDots = 8,
    this.completedDots = 0,
    this.showDolphin = false,
    this.subjectIcon,
  });
}
