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
    required Map<String, dynamic> choices,
  }) {
    // Get correct answer for this question
    final correctMatches = question.data.correctAnswer.selected as Map<String, dynamic>?;
    final matches = correctMatches?['matches'] as Map<String, dynamic>? ?? {};
    final correctChoice = matches[questionKey];
    final selectedChoice = controller.matchingAnswers[questionKey];
    
    // Get colors based on state
    final colorSet = AnswerBoxStyles.getColors(
      isActive: false,
      hasSubmitted: controller.hasSubmitted.value,
      selectedChoice: selectedChoice,
      correctChoice: correctChoice,
      questionKey: questionKey,
    );
    
    Widget answerBoxWidget = DragTarget<Map<String, String?>>(
      builder: (context, candidateData, rejectedData) {
        final isDragHovering = candidateData.isNotEmpty;
        
        return AnswerBox(
          selectedText: selectedChoiceText,
          isActive: isDragHovering, // Highlight when dragging over
          backgroundColor: colorSet.backgroundColor,
          borderColor: isDragHovering 
              ? const Color(0xFF4791DB) // Blue border when hovering
              : colorSet.borderColor,
          shadowColor: isDragHovering 
              ? Colors.transparent // No shadow when hovering
              : colorSet.shadowColor,
          textColor: colorSet.textColor,
          onTap: controller.hasSubmitted.value
              ? null
              : () {
                  // If there's a selected choice, remove it
                  if (selectedChoice != null) {
                    controller.matchingAnswers.remove(questionKey);
                    // Update the submit button state
                    _updateSubmitButtonState();
                  }
                },
        );
      },
      onWillAcceptWithDetails: (details) {
        // Only accept if the slot is empty and not submitted
        return !controller.hasSubmitted.value && 
               !controller.matchingAnswers.containsKey(questionKey);
      },
      onAcceptWithDetails: (details) {
        // Handle drop from another slot
        final sourceQuestionKey = details.data['sourceQuestionKey'];
        final choiceKey = details.data['choiceKey'];
        
        if (sourceQuestionKey != null) {
          // Remove from source slot
          controller.matchingAnswers.remove(sourceQuestionKey);
        }
        
        // Set the answer in this slot
        controller.setMatchingAnswer(questionKey, choiceKey!);
        _updateSubmitButtonState();
      },
    );
    
    // If this slot has a selected choice and there are empty slots, make it draggable
    if (selectedChoice != null && _hasEmptySlots() && !controller.hasSubmitted.value) {
      return Draggable<Map<String, String?>>(
        data: {
          'choiceKey': selectedChoice,
          'sourceQuestionKey': questionKey,
        },
        feedback: Material(
          color: Colors.transparent,
          child: SelectableTag(
            text: selectedChoiceText!,
            backgroundColor: TagStateConfig.defaultState.backgroundColor.withValues(alpha: 0.8),
            borderColor: TagStateConfig.defaultState.borderColor,
            textColor: TagStateConfig.defaultState.textColor,
            shadows: TagStateConfig.defaultState.shadows,
            showText: true,
          ),
        ),
        childWhenDragging: AnswerBox(
          selectedText: null,
          isActive: false,
          backgroundColor: Colors.white,
          borderColor: const Color(0xFFD0D0D0),
          shadowColor: Colors.transparent,
          textColor: Colors.black,
          onTap: null,
        ),
        child: answerBoxWidget,
      );
    }
    
    return answerBoxWidget;
  }

  Widget _buildChoiceTag({
    required String choiceKey,
    required String choiceText,
  }) {
    // Check if this choice is already used
    final isUsed = controller.matchingAnswers.containsValue(choiceKey);
    final isEnabled = !controller.hasSubmitted.value && !isUsed;

    // Determine the tag state based on submission status
    TagStateConfig config = TagStateConfig.defaultState;

    if (controller.hasSubmitted.value) {
      // After submission, all choice options remain grey/disabled
      config = TagStateConfig.selectedState; // Grey without shadows
    } else {
      // Before submission
      if (isUsed) {
        config = TagStateConfig.selectedState; // Grey without shadows for used options
      }
    }

    final tagWidget = SelectableTag(
      text: choiceText,
      backgroundColor: config.backgroundColor,
      borderColor: config.borderColor,
      textColor: config.textColor,
      shadows: config.shadows,
      showText: !isUsed && !controller.hasSubmitted.value, // Hide text when used or after submission
      onTap: null, // Remove onTap since we're using drag and drop
    );

    // If the option is not enabled for dragging, just return the tag
    if (!isEnabled) {
      return tagWidget;
    }

    // Make the tag draggable
    return Draggable<Map<String, String?>>(
      data: {
        'choiceKey': choiceKey,
        'sourceQuestionKey': null, // This is from the options pool, not from another slot
      },
      feedback: Material(
        color: Colors.transparent,
        child: SelectableTag(
          text: choiceText,
          backgroundColor: config.backgroundColor.withValues(alpha: 0.8),
          borderColor: config.borderColor,
          textColor: config.textColor,
          shadows: config.shadows,
          showText: true,
        ),
      ),
      childWhenDragging: SelectableTag(
        text: choiceText,
        backgroundColor: const Color(0xFFE0E0E0),
        borderColor: const Color(0xFFE0E0E0),
        textColor: const Color(0xFF9E9E9E),
        shadows: [],
        showText: false, // Hide text when dragging
      ),
      child: tagWidget,
    );
  }
  
  void _updateSubmitButtonState() {
    // Check if all questions have been answered
    final subQuestions = question.data.options['sub_questions'] as Map<String, dynamic>?;
    if (subQuestions != null) {
      final allAnswered = subQuestions.keys.every((key) => controller.matchingAnswers.containsKey(key));
      controller.selectedOptionIndex.value = allAnswered ? 0 : -1;
    }
  }
  
  bool _hasEmptySlots() {
    final subQuestions = question.data.options['sub_questions'] as Map<String, dynamic>? ?? {};
    return subQuestions.keys.any((key) => !controller.matchingAnswers.containsKey(key));
  }
}
