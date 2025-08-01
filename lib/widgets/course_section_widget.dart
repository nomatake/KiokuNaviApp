import 'package:flutter/material.dart';
import 'package:kioku_navi/utils/app_constants.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/adaptive_sizes.dart';
import 'package:kioku_navi/generated/assets.gen.dart';
import 'package:kioku_navi/widgets/progress_node_widget.dart';
import 'package:kioku_navi/widgets/adaptive_dotted_background.dart';
import 'dart:math';

/// A widget that displays a course section with a zigzag progress pattern.
///
/// This widget shows a course section with:
/// - A section header with title and divider lines
/// - A zigzag pattern of progress nodes with individual properties
/// - Optional dolphins positioned at specific intervals
/// - Support for both left and right alignment patterns
///
/// Each progress node can have:
/// - Individual completion percentage (0-100)
/// - Custom icon or text content
/// - Unique visual state based on completion
///
/// ## Usage Example:
/// ```dart
/// CourseSectionWidget(
///   title: 'Mathematics',
///   isAlignedRight: true,
///   nodes: [
///     CourseNode(
///       completionPercentage: 100.0,
///       customIcon: Icons.add,
///     ),
///     CourseNode(
///       completionPercentage: 75.0,
///       customText: '2',
///     ),
///     CourseNode(
///       completionPercentage: 0.0,
///       customIcon: Icons.multiply,
///     ),
///   ],
///   showDolphin: true,
/// )
/// ```
///
/// The progress nodes can be in three states:
/// - Completed: Blue background with checkmark
/// - Active: White background with play button and progress indicator
/// - Locked: Gray background with lock icon
class CourseSectionWidget extends StatelessWidget {
  // Constants for layout and styling
  static const int _defaultDolphinCount = 1;
  static const int _minimumNodes = 6;
  static const int _nodesPerZigzag = 3;

  // Color constants
  static const Color _primaryBlue = Color(0xFF4BA0EA);
  static const Color _grayBackground = Color(0xFFE0E0E0);

  /// The title text displayed in the section header
  final String title;

  /// Controls the alignment pattern of the zigzag.
  /// - true: dolphin on right (< pattern)
  /// - false: dolphin on left (> pattern)
  final bool isAlignedRight;

  /// List of individual course nodes with their own properties
  final List<CourseNode> nodes;

  /// Whether to show dolphins in the progress section
  final bool showDolphin;

  /// Number of dolphins to display (positioned at every 3rd node)
  final int dolphinCount;

  /// Callback function executed when the widget is tapped
  final VoidCallback? onTap;

  /// Optional key for the section header to track scroll position
  final GlobalKey? headerKey;

  /// Creates a course section widget with progress indicators.
  ///
  /// The [title], [isAlignedRight], and [nodes] parameters are required.
  /// Other parameters have sensible defaults for common use cases.
  /// Each node in [nodes] can have individual icons, text, and completion percentages.
  const CourseSectionWidget({
    super.key,
    required this.title,
    required this.isAlignedRight,
    required this.nodes,
    this.showDolphin = false,
    this.dolphinCount = _defaultDolphinCount,
    this.onTap,
    this.headerKey,
  });

  /// Gets the adaptive node size based on screen width
  static double getAdaptiveNodeSize(BuildContext context) {
    return AdaptiveSizes.getNodeSize(context);
  }

  @override
  Widget build(BuildContext context) {
    final int nodeCount = _calculateNodeCount();

    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(bottom: k1Double.hp),
      child: Column(
        children: [
          _buildSectionHeader(),
          SizedBox(
              height: k2Double
                  .hp), // Add space between header and progress section
          _buildProgressSection(nodeCount, context),
        ],
      ),
    );
  }

  /// Calculates the actual number of nodes to display.
  /// Ensures a minimum number of nodes for proper visual appearance.
  int _calculateNodeCount() {
    return nodes.length < _minimumNodes ? _minimumNodes : nodes.length;
  }

  /// Builds the section header with title and divider lines.
  ///
  /// Returns a row with:
  /// - Left divider line
  /// - Centered title text
  /// - Right divider line
  Widget _buildSectionHeader() {
    final headerRow = Row(
      children: [
        _buildDividerLine(),
        _buildTitleText(),
        _buildDividerLine(),
      ],
    );

    // If headerKey is provided, wrap with Container to track position
    if (headerKey != null) {
      return Container(
        key: headerKey,
        child: headerRow,
      );
    }
    
    return headerRow;
  }

  /// Creates a horizontal divider line for the section header.
  Widget _buildDividerLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: _grayBackground,
      ),
    );
  }

  /// Creates the styled title text for the section header.
  Widget _buildTitleText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: k4Double.wp),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Hiragino Sans',
          fontWeight: FontWeight.w600,
          fontSize: k18Double.sp,
          color: _primaryBlue,
          letterSpacing: -0.36,
        ),
      ),
    );
  }

  /// Builds the progress section containing nodes and optional dolphins.
  ///
  /// Calculates the required height based on node count and spacing,
  /// then creates a stack with dotted background, progress icons and dolphins.
  Widget _buildProgressSection(int nodeCount, BuildContext context) {
    final double sectionHeight =
        _calculateProgressSectionHeight(nodeCount, context);

    return SizedBox(
      height: sectionHeight,
      child: Stack(
        children: [
          // Dotted background layer
          const Positioned.fill(
            child: AdaptiveDottedBackground(),
          ),
          _buildProgressIcons(nodeCount, sectionHeight, context),
          if (showDolphin) ..._buildDolphins(nodeCount, context),
        ],
      ),
    );
  }

  /// Calculates the height needed for the progress section.
  ///
  /// Formula: (nodeCount - 1) * spacingY + nodeSize
  double _calculateProgressSectionHeight(int nodeCount, BuildContext context) {
    final double spacingY = AdaptiveSizes.getNodeVerticalSpacing(context);
    final double nodeSize = getAdaptiveNodeSize(context);
    return (nodeCount - 1) * spacingY + nodeSize;
  }

  /// Builds the container for progress icons with calculated height.
  Widget _buildProgressIcons(int nodeCount, double height, BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: _buildZigzagProgressPattern(nodeCount, context),
      ),
    );
  }

  /// Creates the zigzag pattern of progress nodes.
  ///
  /// Generates a list of positioned widgets forming a zigzag pattern.
  /// The pattern alternates direction every [_nodesPerZigzag] nodes.
  List<Widget> _buildZigzagProgressPattern(int nodeCount, BuildContext context) {
    final List<Widget> icons = [];
    final ZigzagCalculator calculator = ZigzagCalculator(isAlignedRight, context);

    for (int i = 0; i < nodeCount; i++) {
      final NodePosition position = calculator.calculatePosition(i, context);

      // Use the actual node data if available, otherwise create a default node
      final CourseNode node =
          i < nodes.length ? nodes[i] : CourseNode(completionPercentage: 0.0);

      icons.add(
        Positioned(
          left: position.x,
          top: position.y,
          child: _buildProgressNode(node, i, context),
        ),
      );
    }

    return icons;
  }

  /// Determines the state of a progress node based on its completion percentage and position.
  NodeState _determineNodeState(CourseNode node, int index) {
    if (node.completionPercentage >= 100.0) {
      return NodeState.completed;
    } else if (node.completionPercentage > 0.0) {
      return NodeState.active;
    } else {
      // Find the first incomplete node and make it active
      int firstIncompleteIndex =
          nodes.indexWhere((n) => n.completionPercentage < 100.0);
      if (firstIncompleteIndex == -1) firstIncompleteIndex = 0; // fallback

      // The first incomplete node should be active, others should be locked
      return index == firstIncompleteIndex
          ? NodeState.active
          : NodeState.locked;
    }
  }

  /// Builds a single progress node with the specified node data.
  ///
  /// Creates a circular progress indicator using the ProgressNodeWidget.
  Widget _buildProgressNode(CourseNode node, int index, BuildContext context) {
    final NodeState state = _determineNodeState(node, index);
    final double nodeSize = getAdaptiveNodeSize(context);

    return ProgressNodeWidget(
      state: state,
      completionPercentage: node.completionPercentage,
      size: nodeSize,
      customIcon: node.customIcon,
      customText: node.customText,
      onPressed: onTap,
    );
  }

  /// Builds dolphins positioned at specific intervals in the zigzag pattern.
  ///
  /// Places dolphins next to every 3rd node (index 2 in each group of 3).
  /// The number of dolphins is limited by [dolphinCount].
  List<Widget> _buildDolphins(int nodeCount, BuildContext context) {
    final List<Widget> dolphins = [];
    final ZigzagCalculator calculator = ZigzagCalculator(isAlignedRight, context);
    final int maxDolphins = _calculateMaxDolphins(nodeCount);
    final int dolphinsToPlace =
        dolphinCount < maxDolphins ? dolphinCount : maxDolphins;

    int dolphinsPlaced = 0;

    for (int i = 0; i < nodeCount && dolphinsPlaced < dolphinsToPlace; i++) {
      if (_shouldPlaceDolphinAtIndex(i)) {
        final NodePosition nodePosition = calculator.calculatePosition(i, context);
        final DolphinPosition dolphinPosition =
            _calculateDolphinPosition(nodePosition, context);

        dolphins.add(
          Positioned(
            left: dolphinPosition.x,
            top: dolphinPosition.y,
            child: _buildDolphinImage(),
          ),
        );

        dolphinsPlaced++;
      }
    }

    return dolphins;
  }

  /// Calculates the maximum number of dolphins that can be placed.
  int _calculateMaxDolphins(int nodeCount) {
    return (nodeCount / _nodesPerZigzag).floor();
  }

  /// Determines if a dolphin should be placed at the given node index.
  /// Dolphins are placed at every 3rd node (index 2 in each group of 3).
  bool _shouldPlaceDolphinAtIndex(int index) {
    return index % _nodesPerZigzag == 2;
  }

  /// Calculates the position for a dolphin based on the corresponding node position.
  DolphinPosition _calculateDolphinPosition(NodePosition nodePosition, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.06; // 6% of screen width
    final double availableWidth =
        screenWidth - (padding * 2); // Account for PaddedWrapper padding
    final double nodeSize = getAdaptiveNodeSize(context);
    final double centerX = availableWidth / 2 - nodeSize / 2;
    final double dolphinSize = k28Double.wp;
    final double rightMargin = 0; // Remove margin to place at edge
    final double leftMargin = 0; // Remove margin to place at edge

    // Adjust vertical position to center dolphin with node
    final double adjustedY = nodePosition.y + (nodeSize - dolphinSize) / 2;

    // Place dolphin on opposite side of node relative to center
    // Ensure dolphins stay within the available width (accounting for padding)
    final double dolphinX = nodePosition.x < centerX
        ? availableWidth - dolphinSize - rightMargin
        : leftMargin;

    return DolphinPosition(x: dolphinX, y: adjustedY);
  }

  /// Creates a dolphin image widget with proper orientation.
  ///
  /// The dolphin faces the appropriate direction based on [isAlignedRight].
  /// Uses horizontal flip transformation when needed.
  Widget _buildDolphinImage() {
    final double dolphinSize = AppContainerSize.mediumCard.sp;

    return SizedBox(
      width: dolphinSize,
      height: dolphinSize,
      child: isAlignedRight
          ? Assets.images.logo.image(fit: BoxFit.contain)
          : Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: Assets.images.logo.image(fit: BoxFit.contain),
            ),
    );
  }
}

/// Represents a 2D position with x and y coordinates.
class NodePosition {
  final double x;
  final double y;

  const NodePosition({required this.x, required this.y});
}

/// Represents a dolphin's position with x and y coordinates.
class DolphinPosition {
  final double x;
  final double y;

  const DolphinPosition({required this.x, required this.y});
}

/// Utility class for calculating zigzag pattern positions.
///
/// Handles the complex logic of positioning nodes in a zigzag pattern
/// that alternates direction every [_nodesPerZigzag] nodes.
class ZigzagCalculator {
  static const int _nodesPerZigzag = 3;
  static const double _zigzagSpacingMultiplier = 0.8;

  final bool _isAlignedRight;
  final double _spacingX;
  final double _spacingY;
  final double _centerX;
  final double _topPadding;
  final double _availableWidth;

  ZigzagCalculator(this._isAlignedRight, BuildContext context)
      : _spacingX = k16Double.wp,
        _spacingY = _calculateVerticalSpacing(context),
        _availableWidth = _calculateAvailableWidth(context),
        _centerX = _calculateCenterX(context),
        _topPadding = 0;

  static double _calculateVerticalSpacing(BuildContext context) {
    return AdaptiveSizes.getNodeVerticalSpacing(context);
  }

  static double _calculateAvailableWidth(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.06; // 6% of screen width
    return screenWidth - (padding * 2); // Account for PaddedWrapper padding
  }

  static double _calculateCenterX(BuildContext context) {
    final double availableWidth = _calculateAvailableWidth(context);
    return availableWidth / 2 - CourseSectionWidget.getAdaptiveNodeSize(context) / 2;
  }

  /// Calculates the position of a node at the given index in the zigzag pattern.
  NodePosition calculatePosition(int index, BuildContext context) {
    double x = _centerX;
    bool isZig = _isAlignedRight;

    // Calculate x position based on zigzag pattern
    if (index > 0) {
      final int groupIndex = index ~/ _nodesPerZigzag;
      final int positionInGroup = index % _nodesPerZigzag;

      // Determine direction based on group
      isZig = _isAlignedRight;
      for (int i = 0; i < groupIndex; i++) {
        isZig = !isZig;
      }

      // Calculate horizontal offset
      final double groupOffset =
          groupIndex * _spacingX * _zigzagSpacingMultiplier;
      final double positionOffset =
          positionInGroup * _spacingX * _zigzagSpacingMultiplier;

      if (groupIndex > 0) {
        // Continue from previous group's end position
        final bool prevGroupDirection = !isZig;
        final double prevGroupEndX =
            _centerX + (prevGroupDirection ? 1 : -1) * groupOffset;
        x = prevGroupEndX + (isZig ? 1 : -1) * positionOffset;
      } else {
        // First group starts from center
        x = _centerX + (isZig ? 1 : -1) * positionOffset;
      }
    }

    // Add boundary constraints to keep nodes within safe margins
    final double nodeSize = CourseSectionWidget.getAdaptiveNodeSize(context);
    final double margin = 0; // Remove margin to prevent extra left padding
    final double minX = margin;
    final double maxX = _availableWidth - nodeSize - margin;

    // Clamp x position within boundaries
    x = x.clamp(minX, maxX);

    final double y = _topPadding + index * _spacingY;

    return NodePosition(x: x, y: y);
  }
}

/// Data model representing a single course node.
///
/// Contains all the information needed to display an individual progress node
/// including its completion status and visual content.
class CourseNode {
  /// Completion percentage for this node (0-100)
  final double completionPercentage;

  /// Optional custom icon to display on this node
  final IconData? customIcon;

  /// Optional custom text to display on this node
  final String? customText;

  /// Optional identifier for this node
  final String? id;

  /// Creates a course node data model.
  ///
  /// The [completionPercentage] determines the visual state of the node.
  /// Either [customIcon] or [customText] can be provided for custom content.
  const CourseNode({
    this.completionPercentage = 0.0,
    this.customIcon,
    this.customText,
    this.id,
  });
}

/// Data model representing a course section.
///
/// Contains all the information needed to display a course section
/// including individual course nodes and visual configuration.
class CourseSection {
  /// The display title of the course section
  final String title;

  /// Whether the section should use right-aligned pattern
  final bool isAlignedRight;

  /// List of individual course nodes with their own properties
  final List<CourseNode> nodes;

  /// Whether to display dolphins in the section
  final bool showDolphin;

  /// Optional icon identifier for the subject (currently unused)
  final String? subjectIcon;

  /// Creates a course section data model.
  ///
  /// The [title], [isAlignedRight], and [nodes] parameters are required.
  /// Other parameters have sensible defaults.
  const CourseSection({
    required this.title,
    required this.isAlignedRight,
    required this.nodes,
    this.showDolphin = false,
    this.subjectIcon,
  });
}
