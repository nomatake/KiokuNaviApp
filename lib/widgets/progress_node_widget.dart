import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/adaptive_sizes.dart';
import 'package:kioku_navi/widgets/rounded_button.dart';

/// Represents the state of a progress node.
enum NodeState {
  /// Node is completed (blue background with checkmark)
  completed,

  /// Node is currently active (white background with play button)
  active,

  /// Node is locked/unavailable (gray background with lock icon)
  locked,
}

/// A widget that displays a single progress node with different states.
///
/// This widget shows a circular progress indicator that can be in three states:
/// - Completed: Blue background with checkmark
/// - Active: White background with play button and progress indicator
/// - Locked: Gray background with lock icon
class ProgressNodeWidget extends StatelessWidget {
  // Color constants
  static const Color _primaryBlue = Color(0xFF4BA0EA);
  static const Color _completedBlue = Color(0xFF4791DB);
  static const Color _shadowBlue = Color(0xFF1976D2);
  static const Color _grayBackground = Color(0xFFE0E0E0);
  static const Color _grayShadow = Color(0xFFB7B7B7);
  static const Color _progressBackground = Color(0xFFE5E5E5);

  /// The current state of the progress node
  final NodeState state;

  /// Completion percentage (0-100). If 100, node is filled with blue color.
  final double completionPercentage;

  /// Size of the node widget
  final double size;

  /// Optional custom icon to display instead of default state icons
  final IconData? customIcon;

  /// Optional custom text to display instead of default state icons
  final String? customText;

  /// Optional callback when the node is pressed
  final VoidCallback? onPressed;

  /// Creates a progress node widget.
  ///
  /// The [state] parameter is required to determine the visual appearance.
  /// The [completionPercentage] is used for progress calculation (0-100).
  /// The [size] parameter defaults to the standard node size.
  /// The [customIcon] or [customText] parameters allow overriding default state-based content.
  /// Icons and text are always displayed in white color.
  const ProgressNodeWidget({
    super.key,
    required this.state,
    this.completionPercentage = 0.0,
    double? size,
    this.customIcon,
    this.customText,
    this.onPressed,
  }) : size = size ?? 18.0;

  /// Gets the adaptive stroke width based on node size
  static double getAdaptiveStrokeWidth(BuildContext context) {
    return AdaptiveSizes.getProgressStrokeWidth(context);
  }

  /// Gets the adaptive padding between progress and button based on node size
  static double getAdaptivePadding(BuildContext context, double nodeSize) {
    return AdaptiveSizes.getProgressPadding(context, nodeSize);
  }

  @override
  Widget build(BuildContext context) {
    // If there's active progress, show progress indicator around the button
    if (state == NodeState.active && completionPercentage < 100.0) {
      final double adaptivePadding = getAdaptivePadding(context, size);

      return Stack(
        alignment: Alignment.center,
        children: [
          _buildActiveNodeProgress(context),
          Padding(
            padding: EdgeInsets.all(adaptivePadding), // Adaptive padding
            child: _buildRoundedButton(),
          ),
        ],
      );
    }

    // Otherwise, just return the button
    return _buildRoundedButton();
  }

  /// Creates the rounded button based on the node state.
  Widget _buildRoundedButton() {
    final bool isCompleted = completionPercentage >= 100.0;

    // Determine colors based on completion first, then state
    Color backgroundColor;
    Color? shadowColor;
    bool disabled = false;

    // Priority 1: If completed (100%+), always use blue regardless of state
    if (isCompleted || state == NodeState.completed) {
      backgroundColor = _completedBlue;
      shadowColor = _shadowBlue;
      disabled = false;
    } else {
      // Priority 2: Handle non-completed states
      switch (state) {
        case NodeState.completed:
          // This case is already handled above
          backgroundColor = _completedBlue;
          shadowColor = _shadowBlue;
        case NodeState.active:
          backgroundColor = _completedBlue; // Use blue background #4791DB
          shadowColor = _shadowBlue;
        case NodeState.locked:
          backgroundColor = _grayBackground;
          shadowColor = _grayShadow;
          disabled = true;
      }
    }

    return RoundedButton(
      text: _getButtonText(),
      icon: _getButtonIcon(),
      size: size,
      backgroundColor: backgroundColor,
      textColor: _getTextColor(),
      shadowColor: shadowColor,
      disabled: disabled,
      onPressed: disabled ? null : onPressed,
    );
  }

  /// Gets the appropriate text for the button.
  String _getButtonText() {
    if (customText != null) return customText!;
    return ''; // Empty string when using icons
  }

  /// Gets the appropriate icon for the button based on state.
  Widget? _getButtonIcon() {
    if (customText != null)
      return null; // Don't use icon if custom text is provided

    final double iconSize = size * (6.0 / 18.0); // Smaller icons

    if (customIcon != null) {
      return Icon(
        customIcon!,
        color: _getTextColor(),
        size: iconSize,
      );
    }

    // Use state-based icons
    return switch (state) {
      NodeState.completed => Icon(
          Icons.check,
          color: _getTextColor(),
          size: iconSize,
        ),
      NodeState.active => Icon(
          Icons.play_arrow,
          color: Colors.white, // White play arrow on blue background
          size: iconSize,
        ),
      NodeState.locked => Icon(
          Icons.lock_outline,
          color: _grayShadow,
          size: iconSize,
        ),
    };
  }

  /// Gets the appropriate text color based on state.
  Color _getTextColor() {
    final bool isCompleted = completionPercentage >= 100.0;

    // If completed (100%+) or state is completed, always use white text
    if (isCompleted || state == NodeState.completed) {
      return Colors.white;
    }

    return switch (state) {
      NodeState.completed => Colors.white,
      NodeState.active => Colors.white, // White text on blue background
      NodeState.locked => _grayShadow,
    };
  }

  /// Creates a circular progress indicator for nodes with incomplete progress.
  Widget _buildActiveNodeProgress(BuildContext context) {
    // Calculate progress size to wrap around the button + padding
    final double adaptivePadding = getAdaptivePadding(context, size);
    final double paddingSize = adaptivePadding * 2; // padding on both sides
    final double progressSize =
        size + paddingSize + (size * 0.15); // extra space for progress ring
    final double progress = completionPercentage / 100.0;

    // Get adaptive stroke width based on node size
    final double strokeWidth = getAdaptiveStrokeWidth(context);

    return SizedBox(
      width: progressSize,
      height: progressSize,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: strokeWidth,
        valueColor: const AlwaysStoppedAnimation<Color>(_primaryBlue),
        backgroundColor: _progressBackground,
      ),
    );
  }
}
