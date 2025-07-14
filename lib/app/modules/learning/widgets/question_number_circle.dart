import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

/// Reusable question number circle widget
class QuestionNumberCircle extends StatelessWidget {
  final int number;
  final double? topPadding;

  const QuestionNumberCircle({
    super.key,
    required this.number,
    this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: k7Double.wp,
      height: k7Double.wp,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            fontSize: k12Double.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF424242),
          ),
        ),
      ),
    );

    return topPadding != null
        ? Padding(
            padding: EdgeInsets.only(top: topPadding!),
            child: circle,
          )
        : circle;
  }
}