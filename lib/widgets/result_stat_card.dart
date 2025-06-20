import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

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
    return Container(
      width: k25Double.wp,
      height: k10Double.hp,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(k15Double),
      ),
      child: Stack(
        children: [
          // White background for top part
          Positioned(
            top: k3Double,
            left: k3Double,
            right: k3Double,
            bottom: k28Double,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(k13Double),
                  topRight: Radius.circular(k13Double),
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
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Hiragino Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: k17Double.sp,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              // Label section
              Expanded(
                flex: 30,
                child: Center(
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
            ],
          ),
        ],
      ),
    );
  }
}
