class Question {
  final int id;
  final String type;
  final QuestionData data;

  Question({
    required this.id,
    required this.type,
    required this.data,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      type: json['type'],
      data: QuestionData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'data': data.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Question &&
        other.id == id &&
        other.type == type &&
        other.data == data;
  }

  @override
  int get hashCode {
    return id.hashCode ^ type.hashCode ^ data.hashCode;
  }

  @override
  String toString() {
    return 'Question{id: $id, type: $type, data: $data}';
  }

  Question copyWith({
    int? id,
    String? type,
    QuestionData? data,
  }) {
    return Question(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }
}

class QuestionData {
  final String question;
  final String questionType;
  final Map<String, dynamic> options;
  final CorrectAnswer correctAnswer;
  final dynamic metadata;

  QuestionData({
    required this.question,
    required this.questionType,
    required this.options,
    required this.correctAnswer,
    this.metadata,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      question: json['question'],
      questionType: json['question_type'],
      options: json['options'] is List 
          ? {} // For question_answer type, options might be an empty array
          : Map<String, dynamic>.from(json['options'] ?? {}),
      correctAnswer: CorrectAnswer.fromJson(json['correct_answer']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'question_type': questionType,
      'options': options,
      'correct_answer': correctAnswer.toJson(),
      'metadata': metadata,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionData &&
        other.question == question &&
        other.questionType == questionType &&
        other.options.toString() == options.toString() &&
        other.correctAnswer == correctAnswer &&
        other.metadata == metadata;
  }

  @override
  int get hashCode {
    return question.hashCode ^
        questionType.hashCode ^
        options.hashCode ^
        correctAnswer.hashCode ^
        metadata.hashCode;
  }

  @override
  String toString() {
    return 'QuestionData{question: $question, questionType: $questionType, options: $options, correctAnswer: $correctAnswer, metadata: $metadata}';
  }

  QuestionData copyWith({
    String? question,
    String? questionType,
    Map<String, dynamic>? options,
    CorrectAnswer? correctAnswer,
    dynamic metadata,
  }) {
    return QuestionData(
      question: question ?? this.question,
      questionType: questionType ?? this.questionType,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      metadata: metadata ?? this.metadata,
    );
  }
}

class CorrectAnswer {
  final dynamic selected; // Can be String or List<String>

  CorrectAnswer({required this.selected});

  factory CorrectAnswer.fromJson(Map<String, dynamic> json) {
    // For question_matching, the correct answer has 'matches' instead of 'selected'
    if (json.containsKey('matches')) {
      return CorrectAnswer(selected: json);
    }
    // For question_answer, the correct answer has 'answer' instead of 'selected'
    if (json.containsKey('answer')) {
      return CorrectAnswer(selected: json['answer']);
    }
    return CorrectAnswer(selected: json['selected']);
  }

  Map<String, dynamic> toJson() {
    return {'selected': selected};
  }
  
  // Helper getters
  bool get isMultipleSelect => selected is List;
  
  String? get singleAnswer => selected is String ? selected as String : null;
  
  List<String> get multipleAnswers {
    if (selected is List) {
      return List<String>.from(selected);
    }
    return [];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CorrectAnswer && other.selected.toString() == selected.toString();
  }

  @override
  int get hashCode {
    return selected.hashCode;
  }

  @override
  String toString() {
    return 'CorrectAnswer{selected: $selected}';
  }

  CorrectAnswer copyWith({
    dynamic selected,
  }) {
    return CorrectAnswer(
      selected: selected ?? this.selected,
    );
  }
}
