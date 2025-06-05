import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/constants.dart';

class RegisterProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  const RegisterProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kRegisterProgressBarWidth,
      height: kRegisterProgressBarHeight,
      child: Stack(
        children: [
          // Background bar
          Container(
            width: kRegisterProgressBarWidth,
            height: kRegisterProgressBarHeight,
            decoration: BoxDecoration(
              color: kRegisterProgressBarBgColor,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          // Progress bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: kRegisterProgressBarWidth * progress.clamp(0.0, 1.0),
            height: kRegisterProgressBarHeight,
            decoration: BoxDecoration(
              color: kRegisterProgressBarProgressColor,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          // Overlay bar (white, semi-transparent)
          Positioned(
            left: kRegisterProgressBarOverlayLeft,
            top: kRegisterProgressBarOverlayTop,
            child: Container(
              width: kRegisterProgressBarWidth - 2 * kRegisterProgressBarOverlayLeft,
              height: kRegisterProgressBarOverlayHeight,
              decoration: BoxDecoration(
                color: kRegisterProgressBarOverlayColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 