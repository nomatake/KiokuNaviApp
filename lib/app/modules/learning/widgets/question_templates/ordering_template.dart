import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/question.dart';
import 'package:kioku_navi/app/modules/learning/models/tag_state_config.dart';
import 'package:kioku_navi/app/modules/learning/widgets/selectable_tag.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

class OrderingTemplate extends GetView<LearningController> {
  final Question question;

  const OrderingTemplate({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final options = question.data.options;
      final optionKeys = options.keys.toList()..sort();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Three horizontal lines with options flowing on them
          Padding(
            padding: EdgeInsets.symmetric(horizontal: k3Double.wp),
            child: _buildOrderingArea(),
          ),
          SizedBox(height: k1Double.hp),
          // Pool of options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: k3Double.wp),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: k2Double.wp,
                runSpacing: k1Double.hp,
                children: optionKeys.map((optionKey) {
                  return _buildOptionTag(
                    optionKey: optionKey,
                    optionText: options[optionKey] as String,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildOrderingArea() {
    return Obx(() {
      final options = question.data.options;
      final orderedCount = controller.orderingAnswers.length;

      // Calculate lines based on ordered options
      int neededLines = 2; // Start with 2 lines minimum

      if (orderedCount > 0) {
        // Check each option and determine if it would wrap
        // Based on the screenshot, these Japanese options are taking full width
        // So let's check if each option is long enough to take a full line
        int currentLine = 1;
        double currentLineWidth = 0;
        double availableWidth = Get.width - (k6Double.wp * 2); // Total padding

        for (int i = 0; i < controller.orderingAnswers.length; i++) {
          final optionKey = controller.orderingAnswers[i];
          final optionText = options[optionKey] as String;
          // Estimate width: Japanese chars ~15px + padding + margins
          double estimatedWidth = (optionText.length * 15) + (k8Double.wp);

          if (i == 0) {
            // First option
            currentLineWidth = estimatedWidth;
          } else if (currentLineWidth + estimatedWidth > availableWidth) {
            // Would overflow, go to next line
            currentLine++;
            currentLineWidth = estimatedWidth;
          } else {
            // Fits on current line
            currentLineWidth += estimatedWidth;
          }
        }

        neededLines = currentLine.clamp(2, 10);
      }

      final lineHeight = k4_5Double.hp + k2_5Double.hp;
      // Reduce container height to remove extra spacing at bottom
      final containerHeight =
          k6Double.hp + (lineHeight * (neededLines - 1)) + k4_5Double.hp;

      return SizedBox(
        height: containerHeight,
        child: Stack(
          children: [
            // Dynamic horizontal lines
            ...List.generate(neededLines, (index) {
              final topPosition = k6Double.hp + (lineHeight * index);
              return Positioned(
                top: topPosition,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  color: const Color(0xFFD0D0D0),
                ),
              );
            }),
            // Options container - positioned to cover entire area
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildOrderedOptions(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOrderedOptions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DragTarget<Map<String, dynamic>>(
          builder: (_, candidateData, rejectedData) {
            return Container(
              width: double.infinity,
              // Ensure minimum height for drop target
              constraints: BoxConstraints(
                minHeight: k5Double.hp,
              ),
              child: Obx(() {
                if (controller.orderingAnswers.isEmpty) {
                  // Empty drop zone
                  final isHovering = candidateData.isNotEmpty;
                  return Container(
                    height: k5Double.hp,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: isHovering
                          ? Border.all(
                              color: Colors.blue.withAlpha(100), width: 2)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }

                // Build display with placeholders
                final widgets = <Widget>[];
                final hoverPos = controller.dragHoverPosition.value;
                final isDragging = controller.draggedOptionKey.value.isNotEmpty;

                // Add options with placeholders
                for (int i = 0; i <= controller.orderingAnswers.length; i++) {
                  // Show placeholder at hover position
                  if (i == hoverPos && isDragging) {
                    widgets.add(
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: k0_75Double.wp),
                        child: SelectableTag(
                          text: question.data
                                  .options[controller.draggedOptionKey.value]
                              as String,
                          backgroundColor: const Color(0xFFE5E5E5),
                          borderColor: const Color(0xFFBDBDBD),
                          textColor: const Color(0xFF757575),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x1A757575),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                            BoxShadow(
                              color: Color(0xFFBDBDBD),
                              offset: Offset(0, 2),
                              blurRadius: 0,
                              spreadRadius: 0,
                            ),
                          ],
                          showText: false,
                        ),
                      ),
                    );
                  }

                  // Add actual option if exists and not being dragged
                  if (i < controller.orderingAnswers.length) {
                    final optionKey = controller.orderingAnswers[i]!;
                    if (optionKey != controller.draggedOptionKey.value) {
                      final optionText =
                          question.data.options[optionKey] as String;
                      widgets.add(
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: k0_75Double.wp),
                          child: _buildOrderedOption(
                            optionKey: optionKey,
                            optionText: optionText,
                            position: i,
                          ),
                        ),
                      );
                    }
                  }
                }

                return Padding(
                  padding: EdgeInsets.only(top: k0_5Double.hp),
                  child: Wrap(
                    spacing: 0,
                    runSpacing: k2_5Double.hp,
                    alignment: WrapAlignment.start,
                    children: widgets,
                  ),
                );
              }),
            );
          },
          onMove: (details) {
            // Calculate hover position based on drag position
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localPos = box.globalToLocal(details.offset);

            final totalOptions = controller.orderingAnswers.length;
            if (totalOptions == 0) {
              controller.dragHoverPosition.value = 0;
              return;
            }

            // Simple grid-based position calculation
            final itemWidth = k20Double.wp; // Approximate item width
            final itemHeight =
                k4_5Double.hp + k2_5Double.hp; // Item height + gap

            // Calculate which row and column we're hovering over
            final row = (localPos.dy / itemHeight).floor();
            final approximateItemsPerRow = (box.size.width / itemWidth).floor();
            final col = (localPos.dx / itemWidth).floor();

            // Calculate position in the linear list
            int position =
                (row * approximateItemsPerRow + col).clamp(0, totalOptions);

            controller.dragHoverPosition.value = position;
          },
          onLeave: (data) {
            // Only reset hover position if we're not currently dragging
            if (controller.draggedOptionKey.value.isEmpty) {
              controller.dragHoverPosition.value = -1;
            }
          },
          onWillAcceptWithDetails: (details) {
            // Only accept dragging from already placed options (sourcePosition != null)
            final sourcePosition = details.data['sourcePosition'] as int?;
            return !controller.hasSubmitted.value && sourcePosition != null;
          },
          onAcceptWithDetails: (details) {
            final draggedKey = details.data['optionKey'] as String;
            final sourcePosition = details.data['sourcePosition'] as int?;
            int targetPosition = controller.dragHoverPosition.value;

            if (targetPosition < 0) {
              targetPosition = controller.orderingAnswers.length;
            }

            // Create new list
            final newList = controller.orderingAnswers.toList();

            // Remove from source if it exists in the ordered list
            if (sourcePosition != null && sourcePosition < newList.length) {
              newList.removeAt(sourcePosition);
              // Adjust target position if removing before the target
              if (sourcePosition < targetPosition) {
                targetPosition--;
              }
            }

            // Insert at target position
            targetPosition = targetPosition.clamp(0, newList.length);
            newList.insert(targetPosition, draggedKey);

            // Update state
            controller.orderingAnswers.value = newList;
            controller.dragHoverPosition.value = -1;
            controller.draggedOptionKey.value = '';
            _updateSubmitButtonState();
          },
        );
      },
    );
  }

  Widget _buildOrderedOption({
    required String optionKey,
    required String optionText,
    required int position,
  }) {
    // Get colors for validation after submission
    final correctOrder =
        question.data.correctAnswer.selected as Map<String, dynamic>?;
    final order = correctOrder?['order'] as Map<String, dynamic>? ?? {};
    final correctKey = order['position_${position + 1}'];
    final isCorrect = correctKey == optionKey;

    Widget optionWidget = SelectableTag(
      text: optionText,
      backgroundColor: controller.hasSubmitted.value
          ? (isCorrect ? Colors.green.withAlpha(26) : Colors.red.withAlpha(26))
          : TagStateConfig.defaultState.backgroundColor,
      borderColor: controller.hasSubmitted.value
          ? (isCorrect ? Colors.green : Colors.red)
          : TagStateConfig.defaultState.borderColor,
      textColor: controller.hasSubmitted.value
          ? (isCorrect ? Colors.green.shade700 : Colors.red.shade700)
          : TagStateConfig.defaultState.textColor,
      shadows: controller.hasSubmitted.value
          ? []
          : TagStateConfig.defaultState.shadows,
      showText: true,
      onTap: controller.hasSubmitted.value
          ? null
          : () {
              // Remove the option from the list
              controller.orderingAnswers.removeWhere((o) => o == optionKey);
              _updateSubmitButtonState();
            },
    );

    // Make draggable if not submitted
    if (!controller.hasSubmitted.value) {
      optionWidget = Draggable<Map<String, dynamic>>(
        data: {
          'optionKey': optionKey,
          'sourcePosition': position,
        },
        onDragStarted: () {
          controller.draggedOptionKey.value = optionKey;
        },
        onDragEnd: (details) {
          controller.draggedOptionKey.value = '';
          controller.dragHoverPosition.value = -1;
        },
        onDraggableCanceled: (_, __) {
          controller.draggedOptionKey.value = '';
          controller.dragHoverPosition.value = -1;
        },
        feedback: Material(
          color: Colors.transparent,
          child: Transform.scale(
            scale: 1.1,
            child: SelectableTag(
              text: optionText,
              backgroundColor: TagStateConfig.defaultState.backgroundColor,
              borderColor: TagStateConfig.defaultState.borderColor,
              textColor: TagStateConfig.defaultState.textColor,
              shadows: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              showText: true,
            ),
          ),
        ),
        childWhenDragging: optionWidget,
        rootOverlay: true,
        child: optionWidget,
      );
    }

    return optionWidget;
  }

  Widget _buildOptionTag({
    required String optionKey,
    required String optionText,
  }) {
    // Check if this option is already placed
    final isUsed = controller.orderingAnswers.contains(optionKey);
    final isEnabled = !controller.hasSubmitted.value && !isUsed;

    TagStateConfig config = TagStateConfig.defaultState;

    if (controller.hasSubmitted.value || isUsed) {
      config = TagStateConfig.selectedState; // Grey state
    }

    return SelectableTag(
      text: optionText,
      backgroundColor: config.backgroundColor,
      borderColor: config.borderColor,
      textColor: config.textColor,
      shadows: config.shadows,
      showText: !isUsed && !controller.hasSubmitted.value,
      onTap: isEnabled ? () => _addOption(optionKey) : null,
    );
  }

  void _addOption(String optionKey) {
    // Simply add to the end of the list
    controller.orderingAnswers.add(optionKey);
    _updateSubmitButtonState();
  }

  void _updateSubmitButtonState() {
    // Check if all options have been ordered
    final totalOptions = question.data.options.length;
    final orderedCount = controller.orderingAnswers.length;
    controller.selectedOptionIndex.value =
        orderedCount == totalOptions ? 0 : -1;
  }
}
