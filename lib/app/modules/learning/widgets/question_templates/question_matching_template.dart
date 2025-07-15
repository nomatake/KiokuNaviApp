import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/question.dart';
import 'package:kioku_navi/app/modules/learning/models/tag_state_config.dart';
import 'package:kioku_navi/app/modules/learning/utils/answer_box_styles.dart';
import 'package:kioku_navi/app/modules/learning/widgets/answer_box.dart';
import 'package:kioku_navi/app/modules/learning/widgets/question_number_circle.dart';
import 'package:kioku_navi/app/modules/learning/widgets/selectable_tag.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

class QuestionMatchingTemplate extends GetView<LearningController> {
  final Question question;

  const QuestionMatchingTemplate({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final subQuestions =
          question.data.options['sub_questions'] as Map<String, dynamic>? ?? {};
      final choices =
          question.data.options['choices'] as Map<String, dynamic>? ?? {};

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-questions with answer boxes
          ...subQuestions.entries.map((entry) {
            final index = subQuestions.keys.toList().indexOf(entry.key);
            return _buildSubQuestionRow(
              index: index + 1,
              questionKey: entry.key,
              questionText: entry.value as String,
              choices: choices,
            );
          }),

          SizedBox(height: k3Double.hp),

          // Choice options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: k3Double.wp),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: k3Double.wp,
                runSpacing: k1_5Double.hp,
                children: choices.entries.map((entry) {
                  return _buildChoiceTag(
                    choiceKey: entry.key,
                    choiceText: entry.value as String,
                  );
                }).toList(),
              ),
            ),
          ),

          // Add space after the options
          SizedBox(height: k3Double.hp),
        ],
      );
    });
  }

  Widget _buildSubQuestionRow({
    required int index,
    required String questionKey,
    required String questionText,
    required Map<String, dynamic> choices,
  }) {
    final selectedChoiceKey = controller.matchingAnswers[questionKey];
    final selectedChoiceText =
        selectedChoiceKey != null ? choices[selectedChoiceKey] : null;
    final isActiveSelection =
        controller.activeMatchingQuestion.value == questionKey;

    return Padding(
      padding: EdgeInsets.only(
        left: k2Double.wp,
        right: k2Double.wp,
        bottom: k2_5Double.hp,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number
          QuestionNumberCircle(
            number: index,
            topPadding: k0_5Double.hp,
          ),
          SizedBox(width: k2Double.wp),

          // Question text and answer box
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: k14Double.sp,
                        color: const Color(0xFF212121),
                        height: 1.8,
                      ),
                      children: [
                        TextSpan(text: questionText),
                        WidgetSpan(
                          child: SizedBox(width: k4Double.wp),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: _buildAnswerBox(
                            questionKey: questionKey,
                            selectedChoiceText: selectedChoiceText,
                            isActiveSelection: isActiveSelection,
                            choices: choices,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerBox({
    required String questionKey,
    required String? selectedChoiceText,
    required bool isActiveSelection,
    required Map<String, dynamic> choices,
  }) {
    // Get correct answer for this question
    final correctMatches = question.data.correctAnswer.selected as Map<String, dynamic>?;
    final matches = correctMatches?['matches'] as Map<String, dynamic>? ?? {};
    final correctChoice = matches[questionKey];
    final selectedChoice = controller.matchingAnswers[questionKey];
    
    // Get colors based on state
    final colorSet = AnswerBoxStyles.getColors(
      isActive: isActiveSelection,
      hasSubmitted: controller.hasSubmitted.value,
      selectedChoice: selectedChoice,
      correctChoice: correctChoice,
      questionKey: questionKey,
    );
    
    return AnswerBox(
      selectedText: selectedChoiceText,
      isActive: isActiveSelection,
      backgroundColor: colorSet.backgroundColor,
      borderColor: colorSet.borderColor,
      shadowColor: colorSet.shadowColor,
      textColor: colorSet.textColor,
      onTap: controller.hasSubmitted.value
          ? null
          : () {
              // Toggle active selection
              if (isActiveSelection) {
                controller.activeMatchingQuestion.value = '';
              } else {
                controller.activeMatchingQuestion.value = questionKey;
              }
            },
    );
  }

  Widget _buildChoiceTag({
    required String choiceKey,
    required String choiceText,
  }) {
    // Check if this choice is already used
    final isUsed = controller.matchingAnswers.containsValue(choiceKey);
    final isEnabled = !controller.hasSubmitted.value &&
        controller.activeMatchingQuestion.value.isNotEmpty &&
        !isUsed;

    // Determine the tag state based on submission status
    TagStateConfig config = TagStateConfig.defaultState;

    if (controller.hasSubmitted.value) {
      // After submission, all choice options remain grey/disabled
      config = TagStateConfig.selectedState; // Grey without shadows
    } else {
      // Before submission
      if (isUsed) {
        config = TagStateConfig.selectedState; // Grey without shadows for used options
      } else if (!isEnabled) {
        config = TagStateConfig.disabledState; // Grey with shadows for disabled options
      }
    }

    return SelectableTag(
      text: choiceText,
      backgroundColor: config.backgroundColor,
      borderColor: config.borderColor,
      textColor: config.textColor,
      shadows: config.shadows,
      showText: !isUsed && !controller.hasSubmitted.value, // Hide text when used or after submission
      onTap: isEnabled
          ? () {
              // Set the answer for the active question
              controller.setMatchingAnswer(
                controller.activeMatchingQuestion.value,
                choiceKey,
              );
              // Clear active selection
              controller.activeMatchingQuestion.value = '';
            }
          : null,
    );
  }
}
