import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/constants/question_colors.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/question.dart';
import 'package:kioku_navi/app/modules/learning/models/tag_state_config.dart';
import 'package:kioku_navi/app/modules/learning/widgets/selectable_tag.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

class MultipleSelectTemplate extends GetView<LearningController> {
  final Question question;

  const MultipleSelectTemplate({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final options = controller.currentOptions;
      final optionKeys = controller.currentOptionKeys;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected options display area with dynamic underlines
          Padding(
            padding: EdgeInsets.symmetric(horizontal: k2Double.wp),
            child: _buildSelectedOptionsWithUnderlines(options, optionKeys),
          ),

          SizedBox(height: k2Double.hp),

          // Options as secondary buttons in a wrap layout with padding and center alignment
          Padding(
            padding: EdgeInsets.symmetric(horizontal: k3Double.wp),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: k3Double.wp,
                runSpacing: k1_5Double.hp,
                children: List.generate(
                  options.length,
                  (index) {
                    final isSelected = controller.selectedMultipleOptions
                        .contains(optionKeys[index]);
                    final isCorrect =
                        controller.correctAnswerIndices.contains(index);

                    return _buildOptionButton(
                      text: options[index],
                      optionKey: optionKeys[index],
                      index: index,
                      isSelected: isSelected,
                      isCorrect: isCorrect,
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Add space after the options group
          SizedBox(height: k3Double.hp),
        ],
      );
    });
  }

  Widget _buildSelectedTag(String text, String optionKey) {
    final index = controller.currentOptionKeys.indexOf(optionKey);
    final isCorrect = controller.correctAnswerIndices.contains(index);

    TagStateConfig config = TagStateConfig.defaultState;
    
    if (controller.hasSubmitted.value) {
      config = isCorrect 
          ? TagStateConfig.correctState 
          : TagStateConfig.incorrectState;
    }

    return SelectableTag(
      text: text,
      backgroundColor: config.backgroundColor,
      borderColor: config.borderColor,
      textColor: config.textColor,
      shadows: config.shadows,
      onTap: controller.hasSubmitted.value
          ? null
          : () => controller.toggleMultipleOption(optionKey),
    );
  }

  Widget _buildOptionButton({
    required String text,
    required String optionKey,
    required int index,
    required bool isSelected,
    required bool isCorrect,
  }) {
    TagStateConfig config = TagStateConfig.defaultState;
    
    if (!controller.hasSubmitted.value) {
      if (isSelected) {
        config = TagStateConfig.selectedState;
      }
    } else {
      if (isSelected) {
        config = TagStateConfig.selectedState;
      } else if (isCorrect) {
        config = TagStateConfig.unselectedCorrectState;
      }
    }

    return SelectableTag(
      text: text,
      backgroundColor: config.backgroundColor,
      borderColor: config.borderColor,
      textColor: config.textColor,
      shadows: config.shadows,
      showText: !isSelected,
      onTap: controller.hasSubmitted.value || isSelected
          ? null
          : () => controller.toggleMultipleOption(optionKey),
    );
  }

  Widget _buildSelectedOptionsWithUnderlines(
      List<String> options, List<String> optionKeys) {
    // Build list of selected tags with their text for width calculation
    final selectedInfo = <({Widget tag, String text})>[];
    for (final optionKey in controller.selectedMultipleOptions) {
      final index = optionKeys.indexOf(optionKey);
      if (index != -1) {
        selectedInfo.add((
          tag: _buildSelectedTag(options[index], optionKey),
          text: options[index],
        ));
      }
    }

    // Calculate dynamic number of lines based on total options
    final totalOptions = options.length;
    final avgOptionLength = totalOptions > 0 
        ? options.fold<int>(0, (sum, opt) => sum + opt.length) / totalOptions 
        : 0;
    
    // Estimate options per line based on average length
    final optionsPerLine = avgOptionLength <= 10 ? 4 : avgOptionLength <= 15 ? 3 : 2;
    
    // Calculate needed lines (minimum 2, maximum 5)
    final neededLines = ((totalOptions / optionsPerLine).ceil()).clamp(2, 5);

    // Match ordering template spacing
    final lineHeight = k4_5Double.hp + k2_5Double.hp; // option height + spacing (same as ordering)
    final containerHeight = k6Double.hp + (lineHeight * neededLines);

    return SizedBox(
      height: containerHeight,
      child: Stack(
        children: [
          // Dynamic underlines based on needed lines
          ...List.generate(neededLines, (index) {
            final topPosition = k6Double.hp + (lineHeight * index); // Same as ordering template
            return Positioned(
              top: topPosition,
              left: 0,
              right: 0,
              child: Container(
                height: QuestionColors.underlineWidth,
                color: QuestionColors.underlineBorderColor,
              ),
            );
          }),
          // Selected tags container with Wrap for dynamic flow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(top: k0_5Double.hp), // Same padding as ordering
              child: Wrap(
                spacing: k3Double.wp,
                runSpacing: k2_5Double.hp, // Same as ordering template
                children: selectedInfo.map((item) => item.tag).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
