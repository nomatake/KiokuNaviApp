import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/question.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';
import 'package:kioku_navi/widgets/custom_chiclet_button.dart';

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
            child: _buildAnswerButton(
              text: options[index],
              index: index,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAnswerButton({
    required String text,
    required int index,
  }) {
    final hasSubmitted = controller.hasSubmitted.value;
    final isSelected = controller.selectedOptionIndex.value == index;
    final isCorrect = index == controller.correctAnswerIndex;
    final isIncorrect = isSelected && !controller.isCorrect.value;

    if (!hasSubmitted) {
      // Before submission
      if (isSelected) {
        return CustomChicletButton.answerSelected(
          text: text,
          onPressed: () => controller.selectOption(index),
        );
      } else {
        return CustomChicletButton.answerNone(
          text: text,
          onPressed: () => controller.selectOption(index),
        );
      }
    }

    // After submission
    if (isCorrect) {
      return CustomChicletButton.answerCorrect(
        text: text,
        onPressed: null,
      );
    }

    if (isIncorrect) {
      return CustomChicletButton.answerIncorrect(
        text: text,
        onPressed: null,
      );
    }

    // Unselected options after submission should be grayed out
    return CustomChicletButton.answerDisabled(
      text: text,
      onPressed: null,
    );
  }
}