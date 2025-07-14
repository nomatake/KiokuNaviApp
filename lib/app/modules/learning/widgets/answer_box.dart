import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

/// Reusable answer box widget for question matching
class AnswerBox extends StatelessWidget {
  final String? selectedText;
  final bool isActive;
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;
  final Color textColor;
  final VoidCallback? onTap;

  const AnswerBox({
    super.key,
    this.selectedText,
    required this.isActive,
    required this.backgroundColor,
    required this.borderColor,
    required this.shadowColor,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasContent = selectedText != null || isActive;

    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: hasContent
            ? Container(
                constraints: BoxConstraints(minWidth: k20Double.wp),
                height: k5Double.hp,
                padding: EdgeInsets.symmetric(horizontal: k3Double.wp),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(k10Double),
                  border: Border.all(
                    color: borderColor,
                    width: isActive ? 2 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                    BoxShadow(
                      color: borderColor,
                      offset: const Offset(0, 2),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: selectedText != null
                      ? Text(
                          selectedText!,
                          style: TextStyle(
                            fontSize: k13Double.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        )
                      : null,
                ),
              )
            : DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  dashPattern: const [8, 4],
                  strokeWidth: 1.5,
                  radius: Radius.circular(k10Double),
                  color: const Color(0xFFD0D0D0),
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  constraints: BoxConstraints(minWidth: k20Double.wp),
                  height: k5Double.hp,
                  padding: EdgeInsets.symmetric(horizontal: k3Double.wp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(k10Double),
                  ),
                ),
              ),
      ),
    );
  }
}