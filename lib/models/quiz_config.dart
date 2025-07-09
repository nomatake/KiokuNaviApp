import 'package:kioku_navi/models/question.dart';

class QuizConfig {
  final String? curriculumId;
  final String? conceptId;
  final int questionCount;
  final List<int> difficulties;
  final List<QuestionFormat> formats;
  
  QuizConfig({
    this.curriculumId,
    this.conceptId,
    required this.questionCount,
    required this.difficulties,
    required this.formats,
  }) {
    if (curriculumId == null && conceptId == null) {
      throw ArgumentError('Either curriculumId or conceptId must be provided');
    }
  }
  
  Map<String, dynamic> toJson() {
    return {
      'curriculum_id': curriculumId,
      'concept_id': conceptId,
      'question_count': questionCount,
      'difficulties': difficulties,
      'formats': formats.map((f) => f.toString().split('.').last).toList(),
    };
  }
}