import "package:flutter/material.dart";
import "package:kioku_navi/utils/extensions.dart";
import "package:kioku_navi/utils/sizes.dart";


class CustomTitleText extends StatelessWidget {
  const CustomTitleText({
    required this.text,
    this.fontSize,
    this.textColor,
    this.textAlign = TextAlign.center,
    this.maxLines = k1,
    this.fontWeight = FontWeight.w700,
    super.key,
  });

  final String text;
  final double? fontSize;
  final Color? textColor;
  final TextAlign textAlign;
  final int maxLines;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: TextStyle(
        color: textColor ?? Colors.black,
        fontSize: fontSize?.sp ?? k14Double.sp,
        fontWeight: fontWeight,
        letterSpacing: kNeg0_5Double,
      ),
    );
  }
}
