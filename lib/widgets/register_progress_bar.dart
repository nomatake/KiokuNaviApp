import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/constants.dart';

class RegisterProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  const RegisterProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        return SizedBox(
          width: double.infinity,
          height: kRegisterProgressBarHeight,
          child: Stack(
            children: [
              // Background bar
              Container(
                width: barWidth,
                height: kRegisterProgressBarHeight,
                decoration: BoxDecoration(
                  color: kRegisterProgressBarBgColor,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              // Progress bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: barWidth * progress.clamp(0.0, 1.0),
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
                  width: barWidth - 2 * kRegisterProgressBarOverlayLeft,
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
      },
    );
  }
}
