enum QuestionFormat { single, multi, match, sequence, numericInput }

class Question {
  final String questionId;
  final String conceptId;
  final String? curriculumId;
  final String subject;
  final int grade;
  final int difficulty;
  final QuestionFormat format;
  final String stem;
  final List<String>? options;
  final String answer;
  final String? imageRef;
  final String explanation;
  
  Question({
    required this.questionId,
    required this.conceptId,
    this.curriculumId,
    required this.subject,
    required this.grade,
    required this.difficulty,
    required this.format,
    required this.stem,
    this.options,
    required this.answer,
    this.imageRef,
    required this.explanation,
  });
  
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'],
      conceptId: json['concept_id'],
      curriculumId: json['curriculum_id'],
      subject: json['subject'],
      grade: json['grade'],
      difficulty: json['difficulty'],
      format: _parseFormat(json['format']),
      stem: json['stem'],
      options: json['options'] != null 
          ? List<String>.from(json['options']) 
          : null,
      answer: json['answer'],
      imageRef: json['image_ref'],
      explanation: json['explanation'],
    );
  }
  
  static QuestionFormat _parseFormat(String format) {
    switch (format) {
      case 'single':
        return QuestionFormat.single;
      case 'multi':
        return QuestionFormat.multi;
      case 'match':
        return QuestionFormat.match;
      case 'sequence':
        return QuestionFormat.sequence;
      case 'numericInput':
        return QuestionFormat.numericInput;
      default:
        throw ArgumentError('Unknown question format: $format');
    }
  }
  
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'concept_id': conceptId,
      'curriculum_id': curriculumId,
      'subject': subject,
      'grade': grade,
      'difficulty': difficulty,
      'format': format.toString().split('.').last,
      'stem': stem,
      'options': options,
      'answer': answer,
      'image_ref': imageRef,
      'explanation': explanation,
    };
  }
}