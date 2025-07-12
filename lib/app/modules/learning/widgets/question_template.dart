import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

import 'question_templates/fill_blank_template.dart';
import 'question_templates/multiple_choice_template.dart';
import 'question_templates/true_false_template.dart';

class QuestionTemplate extends GetView<LearningController> {
  const QuestionTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final question = controller.currentQuestion;
      
      if (question == null) {
        return const SizedBox.shrink();
      }
      
      // Select template based on question type
      switch (question.data.questionType.toLowerCase()) {
        case 'multiple_choice':
        case 'multiple-choice':
          return MultipleChoiceTemplate(question: question);
          
        case 'true_false':
        case 'true-false':
        case 'true/false':
          return TrueFalseTemplate(question: question);
          
        case 'fill_blank':
        case 'fill-blank':
        case 'fill_in_the_blank':
          return FillBlankTemplate(question: question);
          
        // Add more question types as needed
        // case 'matching':
        //   return MatchingTemplate(question: question);
        // case 'ordering':
        //   return OrderingTemplate(question: question);
        // case 'drag_drop':
        //   return DragDropTemplate(question: question);
          
        default:
          // Fallback to multiple choice for unknown types
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(k2Double.wp),
                margin: EdgeInsets.only(bottom: k2Double.hp),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(26),
                  borderRadius: BorderRadius.circular(k10Double),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: k20Double.sp,
                    ),
                    SizedBox(width: k2Double.wp),
                    Expanded(
                      child: Text(
                        'Unknown question type: ${question.data.questionType}. Using default template.',
                        style: TextStyle(
                          fontSize: k12Double.sp,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MultipleChoiceTemplate(question: question),
            ],
          );
      }
    });
  }
}