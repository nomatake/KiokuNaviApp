import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/constants/question_colors.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/question.dart';
import 'package:kioku_navi/app/modules/learning/models/tag_state_config.dart';
import 'package:kioku_navi/app/modules/learning/utils/layout_calculator.dart';
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

          SizedBox(height: k6Double.hp),

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

    Widget tag = SelectableTag(
      text: text,
      backgroundColor: config.backgroundColor,
      borderColor: config.borderColor,
      textColor: config.textColor,
      shadows: config.shadows,
      onTap: controller.hasSubmitted.value
          ? null
          : () => controller.toggleMultipleOption(optionKey),
    );
    
    // Wrap with IgnorePointer after submission to prevent animations
    if (controller.hasSubmitted.value) {
      tag = IgnorePointer(
        child: tag,
      );
    }
    
    return tag;
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

    Widget tag = SelectableTag(
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
    
    // Wrap with IgnorePointer after submission to prevent animations
    if (controller.hasSubmitted.value) {
      tag = IgnorePointer(
        child: tag,
      );
    }
    
    return tag;
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

    // Use LayoutCalculator to distribute tags across lines
    final lines = LayoutCalculator.distributeTagsAcrossLines(selectedInfo, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Three underlines with dynamic content
        for (int i = 0; i < 3; i++) ...[
          if (i > 0) SizedBox(height: k2Double.hp),
          Container(
            width: double.infinity,
            // Always use the same total height
            constraints: BoxConstraints(minHeight: k5Double.hp + k1_5Double.hp),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: QuestionColors.underlineBorderColor,
                  width: QuestionColors.underlineWidth,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: k1_5Double.hp),
              child: SizedBox(
                height: k5Double.hp,
                child: lines[i].isNotEmpty
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (int j = 0; j < lines[i].length; j++) ...[
                            if (j > 0) SizedBox(width: k3Double.wp),
                            lines[i][j].tag,
                          ],
                        ],
                      )
                    : null,
              ),
            ),
          ),
        ],
      ],
    );
  }

}
