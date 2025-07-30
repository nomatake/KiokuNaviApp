import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/question.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

class AnswerResultWidget extends GetView<LearningController> {
  final Question question;
  final bool isCorrect;

  const AnswerResultWidget({
    super.key,
    required this.question,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show anything for correct answers
    if (isCorrect) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: k6Double.wp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Correct Answer:",
            style: TextStyle(
                fontSize: k14Double.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFB71C1C),
                letterSpacing: -0.5),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: k0_5Double.hp),
          _buildCorrectAnswerDisplay(),
          SizedBox(height: k1_5Double.hp),
        ],
      ),
    );
  }

  Widget _buildCorrectAnswerDisplay() {
    final questionType = question.data.questionType.toLowerCase();

    // For question_answer type only
    if (questionType.contains('question_answer') ||
        questionType.contains('question-answer')) {
      return Text(
        question.data.correctAnswer.selected?.toString() ?? '',
        style: TextStyle(
          fontSize: k13Double.sp,
          fontWeight: FontWeight.w600,
          color: Colors.red.shade800,
        ),
      );
    }

    // Return empty if not question_answer type
    return const SizedBox.shrink();
    
    /* // Commented out for now - only showing for question_answer type
    // For fill_blank types
    if (questionType.contains('fill') ||
        questionType.contains('blank')) {
      return Text(
        question.data.correctAnswer.selected?.toString() ?? '',
        style: TextStyle(
          fontSize: k13Double.sp,
          fontWeight: FontWeight.w600,
          color: Colors.red.shade800,
        ),
      );
    }

    if (questionType.contains('multiple_choice') ||
        questionType.contains('multiple-choice') ||
        questionType.contains('true_false') ||
        questionType.contains('true-false')) {
      final correctKey = question.data.correctAnswer.selected;
      final correctValue =
          question.data.options[correctKey]?.toString() ?? correctKey;

      return Text(
        correctValue,
        style: TextStyle(
          fontSize: k16Double.sp,
          fontWeight: FontWeight.w500,
          color: Colors.red.shade600,
        ),
      );
    }

    // For multiple select
    if (questionType.contains('multiple_select') ||
        questionType.contains('multiple-select')) {
      final correctKeys = question.data.correctAnswer.multipleAnswers;
      final correctValues = correctKeys.map((key) {
        return question.data.options[key]?.toString() ?? key;
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: correctValues
            .map((value) => Padding(
                  padding: EdgeInsets.only(bottom: k0_5Double.hp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• ",
                        style: TextStyle(
                          fontSize: k16Double.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.red.shade600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: k16Double.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      );
    }

    // For question matching
    if (questionType.contains('matching')) {
      final correctMatches =
          question.data.correctAnswer.selected as Map<String, dynamic>;
      if (correctMatches.containsKey('matches')) {
        final matches = correctMatches['matches'] as Map<String, dynamic>;
        final subQuestions =
            question.data.options['sub_questions'] as Map<String, dynamic>;
        final choices =
            question.data.options['choices'] as Map<String, dynamic>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: matches.entries.map((entry) {
            final questionText =
                subQuestions[entry.key]?.toString() ?? entry.key;
            final answerText = choices[entry.value]?.toString() ?? entry.value;

            return Padding(
              padding: EdgeInsets.only(bottom: k1Double.hp),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: k14Double.sp,
                    color: Colors.red.shade700,
                  ),
                  children: [
                    TextSpan(
                      text: questionText,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: " → "),
                    TextSpan(
                      text: answerText,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }
    }

    // Default fallback
    return Text(
      question.data.correctAnswer.selected?.toString() ?? 'N/A',
      style: TextStyle(
        fontSize: k16Double.sp,
        fontWeight: FontWeight.w500,
        color: Colors.red.shade600,
      ),
    );
    */
  }
}
