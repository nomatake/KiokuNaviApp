import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/modules/learning/controllers/learning_controller.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

import 'question_templates/fill_blank_template.dart';
import 'question_templates/multiple_choice_template.dart';
import 'question_templates/multiple_select_template.dart';
import 'question_templates/question_answer_template.dart';
import 'question_templates/question_matching_template.dart';
import 'question_templates/true_false_template.dart';
import 'question_templates/ordering_template.dart';

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
          return MultipleChoiceTemplate(question: question);
          
        case 'multiple_select':
          return MultipleSelectTemplate(question: question);
          
        case 'true_false':
          return TrueFalseTemplate(question: question);
          
        case 'fill_blank':
          return FillBlankTemplate(question: question);
          
        case 'question_matching':
          return QuestionMatchingTemplate(question: question);
          
        case 'question_answer':
          return QuestionAnswerTemplate(
            key: ValueKey(question.id),
            question: question,
          );

        case 'ordering':
          return OrderingTemplate(question: question);

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