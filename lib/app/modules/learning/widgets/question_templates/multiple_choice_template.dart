import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/question.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/answer_option_button.dart';

class MultipleChoiceTemplate extends GetView<LearningController> {
  final Question question;
  
  const MultipleChoiceTemplate({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final options = controller.currentOptions;
      
      return Column(
        children: List.generate(
          options.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: k2Double.hp),
            child: AnswerOptionButton(
              text: options[index],
              state: _getAnswerState(index),
              onPressed: controller.hasSubmitted.value
                  ? null
                  : () => controller.selectOption(index),
            ),
          ),
        ),
      );
    });
  }

  AnswerState _getAnswerState(int index) {
    if (!controller.hasSubmitted.value) {
      return controller.selectedOptionIndex.value == index
          ? AnswerState.selected
          : AnswerState.none;
    }

    if (index == controller.correctAnswerIndex) {
      return AnswerState.correct;
    }

    if (index == controller.selectedOptionIndex.value &&
        !controller.isCorrect.value) {
      return AnswerState.incorrect;
    }

    return AnswerState.none;
  }
}