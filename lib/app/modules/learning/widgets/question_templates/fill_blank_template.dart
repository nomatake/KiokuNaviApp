import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/app/modules/learning/models/question.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

class FillBlankTemplate extends GetView<LearningController> {
  final Question question;
  final TextEditingController textController = TextEditingController();
  
  FillBlankTemplate({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSubmitted = controller.hasSubmitted.value;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field
          TextField(
            controller: textController,
            enabled: !isSubmitted,
            decoration: InputDecoration(
              hintText: "Enter answer",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(k10Double),
              ),
              filled: true,
              fillColor: isSubmitted
                  ? (controller.isCorrect.value
                      ? Colors.green.withAlpha(26)  // 0.1 * 255 = 25.5
                      : Colors.red.withAlpha(26))
                  : Colors.grey.withAlpha(26),
            ),
            style: TextStyle(
              fontSize: k16Double.sp,
              color: const Color(0xFF212121),
            ),
            onChanged: (value) {
              // Update the text answer in controller
              controller.setTextAnswer(value);
            },
          ),
          
          // Show correct answer after submission
          if (isSubmitted && !controller.isCorrect.value) ...[
            SizedBox(height: k2Double.hp),
            Text(
              'Correct answer: ${controller.currentQuestion?.data.correctAnswer.selected}',
              style: TextStyle(
                fontSize: k14Double.sp,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      );
    });
  }
}