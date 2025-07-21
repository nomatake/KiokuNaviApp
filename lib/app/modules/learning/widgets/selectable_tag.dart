import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/accessibility_helper.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

/// A reusable tag widget for multiple select questions with chiclet animation
class SelectableTag extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final List<BoxShadow> shadows;
  final VoidCallback? onTap;
  final bool showText;

  const SelectableTag({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.shadows,
    this.onTap,
    this.showText = true,
  });

  @override
  State<SelectableTag> createState() => _SelectableTagState();
}

class _SelectableTagState extends State<SelectableTag> {
  bool _isPressed = false;
  
  // Shadow height for chiclet effect
  static const double _shadowHeight = 2.0;

  @override
  Widget build(BuildContext context) {
    // Don't treat disabled as pressed - let the animation work independently
    final isPressed = _isPressed;
    
    // Get shadow color from the shadows list or use borderColor
    final shadowColor = widget.shadows.isNotEmpty && widget.shadows.length > 1 
        ? widget.shadows[1].color 
        : widget.borderColor;
    
    return RepaintBoundary(
      child: IntrinsicWidth(
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.onTap == null ? null : () async {
          // Small delay to show animation before action
          await Future.delayed(const Duration(milliseconds: 80));
          if (mounted && widget.onTap != null) {
            widget.onTap!();
          }
        },
          behavior: HitTestBehavior.opaque,
          child: Container(
          height: isPressed ? k5Double.hp : k5Double.hp + _shadowHeight,
          margin: EdgeInsets.only(top: isPressed ? _shadowHeight : 0),
          padding: EdgeInsets.only(
            bottom: isPressed ? 0 : _shadowHeight,
          ),
          decoration: BoxDecoration(
            color: shadowColor,
            borderRadius: BorderRadius.circular(k10Double),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: k2_5Double.wp,
            ),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(k10Double),
              border: Border.all(
                color: widget.borderColor,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: k13Double.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  color: widget.showText ? widget.textColor : Colors.transparent,
                ),
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
      // Provide haptic feedback when the tag is interactive
      if (widget.onTap != null) {
        AccessibilityHelper.provideTapFeedback();
      }
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