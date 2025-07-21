import 'package:flutter/material.dart';

import '../../enums/button_group_positions.dart';
import '../../enums/button_types.dart';
import 'chiclet_button.dart';

// ignore: must_be_immutable
class ChicletButtonSegment<T> extends StatefulWidget {
  ButtonPositions? buttonPosition;

  /// Typically the button's label.
  final Widget child;

  /// Whether the button is currently pressed or not.
  final bool isPressed;

  /// The width of the button.
  ///
  /// If not given, it will be the same as [height].
  double? width;

  /// The height of the button's surface.
  double? height;

  /// The minimum size of the button itself.
  final Size? minimumSize;

  /// The maximum size of the button itself.
  final Size? maximumSize;

  /// The height of the button.
  ///
  /// It applies in addition to the [height].
  double buttonHeight;

  /// The border radius of the button's corners.
  double borderRadius;

  /// The color of the button.
  ///
  /// If [backgroundColor] is given, it will be shade.900 of [backgroundColor].
  /// If neither [backgroundColor] nor [buttonColor] is given, it will be the shade.900 of ThemeData's primarySwatch.
  Color? buttonColor;

  /// The color for the button's Text and Icon widget descendants.
  Color? foregroundColor;

  /// The color of the button's surface.
  ///
  /// If not given, it will be the same as ThemeData's primarySwatch.
  Color? backgroundColor;

  /// The color for the disabled button's Text and Icon widget descendants.
  Color? disabledForegroundColor;

  /// The color of the disabled button's surface.
  Color? disabledBackgroundColor;

  /// The shape of the button.
  ///
  /// The available options are: roundedRectangle (the default shape), circle, and oval.
  ButtonTypes buttonType;

  /// Called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  /// The padding between the button's boundary and its child.
  EdgeInsetsGeometry? padding;

  /// Creates the InkWell splash factory, which defines the appearance of "ink" splashes that occur in response to taps.
  InteractiveInkFeatureFactory? splashFactory;

  ChicletButtonSegment(
      {super.key,
      this.height,
      double? buttonHeight,
      double? borderRadius,
      ButtonTypes? buttonType,
      this.buttonPosition,
      InteractiveInkFeatureFactory? splashFactory,
      this.onPressed,
      this.padding,
      this.width,
      this.minimumSize,
      this.maximumSize,
      this.isPressed = false,
      this.buttonColor,
      this.foregroundColor = Colors.white,
      this.backgroundColor,
      this.disabledForegroundColor,
      this.disabledBackgroundColor,
      required this.child})
      : buttonHeight = buttonHeight ?? 4,
        borderRadius = borderRadius ?? 16,
        buttonType = buttonType ?? ButtonTypes.roundedRectangle,
        splashFactory = splashFactory ?? NoSplash.splashFactory;

  @override
  State<ChicletButtonSegment<T>> createState() =>
      _ChicletAnimatedButtonState<T>();
}

class _ChicletAnimatedButtonState<T> extends State<ChicletButtonSegment<T>>
    with SingleTickerProviderStateMixin {
  late bool _isPressed = widget.isPressed;
  static const Duration duration = Duration(milliseconds: 80);

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    return GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ChicletButton(
            buttonPosition: widget.buttonPosition,
            onPressed: !isDisabled ? _handleButtonPress : null,
            padding: widget.padding,
            width: widget.width,
            height: widget.height ?? 50,
            minimumSize: widget.minimumSize,
            maximumSize: widget.maximumSize,
            isPressed: isDisabled ? true : _isPressed,
            buttonHeight: widget.buttonHeight,
            borderRadius: widget.borderRadius,
            buttonColor: widget.buttonColor,
            foregroundColor: widget.foregroundColor,
            backgroundColor: widget.backgroundColor,
            disabledForegroundColor: widget.disabledForegroundColor,
            disabledBackgroundColor: widget.disabledBackgroundColor,
            splashFactory: widget.splashFactory,
            buttonType: widget.buttonType,
            child: widget.child));
  }

  Future<void> _handleButtonPress() async {
    setState(() {
      _isPressed = true;
      if (widget.onPressed != null) {
        widget.onPressed!();
      }
    });
    await Future.delayed(duration, () {
      setState(() {
        _isPressed = false;
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }
}
