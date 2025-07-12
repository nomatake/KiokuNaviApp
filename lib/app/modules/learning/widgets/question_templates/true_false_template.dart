import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/question.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/answer_option_button.dart';

class TrueFalseTemplate extends GetView<LearningController> {
  final Question question;
  
  const TrueFalseTemplate({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // For true/false, we always have exactly 2 options
      final trueFalseOptions = [
        'True',
        'False',
      ];
      
      return Column(
        children: [
          // True button
          Padding(
            padding: EdgeInsets.only(bottom: k2Double.hp),
            child: AnswerOptionButton(
              text: trueFalseOptions[0],
              state: _getAnswerState(0),
              onPressed: controller.hasSubmitted.value
                  ? null
                  : () => controller.selectOption(0),
            ),
          ),
          // False button
          AnswerOptionButton(
            text: trueFalseOptions[1],
            state: _getAnswerState(1),
            onPressed: controller.hasSubmitted.value
                ? null
                : () => controller.selectOption(1),
          ),
        ],
      );
    });
  }

  AnswerState _getAnswerState(int index) {
    if (!controller.hasSubmitted.value) {
      return controller.selectedOptionIndex.value == index
          ? AnswerState.selected
          : AnswerState.none;
    }

    // For true/false, check if the selected true/false matches the correct answer
    final correctAnswerIsTrue = controller.currentQuestion?.data.correctAnswer.selected == 'a';
    final correctIndex = correctAnswerIsTrue ? 0 : 1;

    if (index == correctIndex) {
      return AnswerState.correct;
    }

    if (index == controller.selectedOptionIndex.value && index != correctIndex) {
      return AnswerState.incorrect;
    }

    return AnswerState.none;
  }
}