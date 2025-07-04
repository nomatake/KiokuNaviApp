import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/app_constants.dart';

class ResultStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const ResultStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  factory ResultStatCard.orange({
    required String value,
    required String label,
  }) {
    return ResultStatCard(
      value: value,
      label: label,
      backgroundColor: const Color(0xFFF57C00),
      textColor: const Color(0xFFF57C00),
    );
  }

  factory ResultStatCard.blue({
    required String value,
    required String label,
  }) {
    return ResultStatCard(
      value: value,
      label: label,
      backgroundColor: const Color(0xFF1CB0F6),
      textColor: const Color(0xFF1CB0F6),
    );
  }

  factory ResultStatCard.green({
    required String value,
    required String label,
  }) {
    return ResultStatCard(
      value: value,
      label: label,
      backgroundColor: const Color(0xFF43A047),
      textColor: const Color(0xFF43A047),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: k350Double.sp,
        maxHeight: k80Double.sp,
      ),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          child: Stack(
            children: [
              // White background for top part
              Positioned(
                top: k3Double,
                left: k3Double,
                right: k3Double,
                bottom: 0,
                child: FractionallySizedBox(
                  heightFactor: 0.7, // 70% of the card height for white area
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppBorderRadius.md),
                        topRight: Radius.circular(AppBorderRadius.md),
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Column(
                children: [
                  // Value section
                  Expanded(
                    flex: 70,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.buttonSpacing),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: 'Hiragino Sans',
                              fontWeight: FontWeight.w800,
                              fontSize: k18Double.sp,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Label section
                  Expanded(
                    flex: 30,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.buttonSpacing),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            label,
                            style: TextStyle(
                              fontFamily: 'Hiragino Sans',
                              fontWeight: FontWeight.w600,
                              fontSize: k12Double.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
