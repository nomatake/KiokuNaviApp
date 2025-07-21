import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

/// Reusable answer box widget for question matching
class AnswerBox extends StatefulWidget {
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
  State<AnswerBox> createState() => _AnswerBoxState();
}

class _AnswerBoxState extends State<AnswerBox> {
  bool _isPressed = false;
  
  // Shadow height for chiclet effect
  static const double _shadowHeight = 2.0;

  @override
  Widget build(BuildContext context) {
    final hasContent = widget.selectedText != null || widget.isActive;
    final isPressed = _isPressed;

    return RepaintBoundary(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: IntrinsicWidth(
        child: hasContent
            ? Container(
                constraints: BoxConstraints(minWidth: k20Double.wp),
                height: isPressed ? k5Double.hp : k5Double.hp + _shadowHeight,
                margin: EdgeInsets.only(top: isPressed ? _shadowHeight : 0),
                padding: EdgeInsets.only(
                  bottom: isPressed ? 0 : _shadowHeight,
                ),
                decoration: BoxDecoration(
                  color: widget.borderColor, // Use border color for shadow
                  borderRadius: BorderRadius.circular(k10Double),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: k2_5Double.wp),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(k10Double),
                    border: Border.all(
                      color: widget.borderColor,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: widget.selectedText != null
                        ? Text(
                            widget.selectedText!,
                            style: TextStyle(
                              fontSize: k13Double.sp,
                              fontWeight: FontWeight.w500,
                              color: widget.textColor,
                            ),
                          )
                        : null,
                  ),
                ),
              )
            : Container(
                constraints: BoxConstraints(minWidth: k20Double.wp),
                height: k5Double.hp + _shadowHeight,
                padding: EdgeInsets.only(bottom: _shadowHeight),
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    dashPattern: const [8, 4],
                    strokeWidth: 1.5,
                    radius: Radius.circular(k10Double),
                    color: const Color(0xFFD0D0D0),
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    height: k5Double.hp,
                    padding: EdgeInsets.symmetric(horizontal: k2_5Double.wp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(k10Double),
                    ),
                  ),
                ),
              ),
      ),
      ),
    );
  }
  
  void _onTapDown(TapDownDetails details) {
    // Always show press animation, even if onTap is null
    if (mounted) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    // Always release the press animation
    if (mounted) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _onTapCancel() {
    // Always release the press animation
    if (mounted) {
      setState(() {
        _isPressed = false;
      });
    }
  }
}