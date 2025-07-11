class UserAnswer {
  final int questionId;
  final String selectedOption;
  final bool isCorrect;
  final DateTime answeredAt;

  UserAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
    required this.answeredAt,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      questionId: json['question_id'],
      selectedOption: json['selected_option'],
      isCorrect: json['is_correct'],
      answeredAt: DateTime.parse(json['answered_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'selected_option': selectedOption,
      'is_correct': isCorrect,
      'answered_at': answeredAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserAnswer &&
        other.questionId == questionId &&
        other.selectedOption == selectedOption &&
        other.isCorrect == isCorrect &&
        other.answeredAt == answeredAt;
  }

  @override
  int get hashCode {
    return questionId.hashCode ^
        selectedOption.hashCode ^
        isCorrect.hashCode ^
        answeredAt.hashCode;
  }

  @override
  String toString() {
    return 'UserAnswer{questionId: $questionId, selectedOption: $selectedOption, isCorrect: $isCorrect, answeredAt: $answeredAt}';
  }

  UserAnswer copyWith({
    int? questionId,
    String? selectedOption,
    bool? isCorrect,
    DateTime? answeredAt,
  }) {
    return UserAnswer(
      questionId: questionId ?? this.questionId,
      selectedOption: selectedOption ?? this.selectedOption,
      isCorrect: isCorrect ?? this.isCorrect,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }
}
