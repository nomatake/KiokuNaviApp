import '../models/models.dart';

class ProgressTracker {
  final List<UserAnswer> _answers = [];

  /// Adds a user answer to the tracker
  void addAnswer(UserAnswer answer) {
    _answers.add(answer);
  }

  /// Gets the total number of questions answered
  int get totalQuestions => _answers.length;

  /// Gets the number of correct answers
  int get correctAnswers => _answers.where((answer) => answer.isCorrect).length;

  /// Gets the score as a percentage
  double get scorePercentage =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

  /// Gets all answers
  List<UserAnswer> get allAnswers => List.unmodifiable(_answers);

  /// Gets only correct answers
  List<UserAnswer> get correctAnswersList =>
      _answers.where((answer) => answer.isCorrect).toList();

  /// Gets only incorrect answers
  List<UserAnswer> get incorrectAnswers =>
      _answers.where((answer) => !answer.isCorrect).toList();

  /// Gets summary for a specific topic
  Map<String, dynamic> getTopicSummary(int topicId) {
    // Note: This is a simplified implementation
    // In a real app, you'd need to map question IDs to topic IDs
    final topicAnswers = _answers
        .where((answer) =>
            answer.questionId >= topicId * 100 &&
            answer.questionId < (topicId + 1) * 100)
        .toList();

    return {
      'topic_id': topicId,
      'total_questions': topicAnswers.length,
      'correct_answers': topicAnswers.where((a) => a.isCorrect).length,
      'score_percentage': topicAnswers.isNotEmpty
          ? (topicAnswers.where((a) => a.isCorrect).length /
                  topicAnswers.length) *
              100
          : 0,
      'completed_at':
          topicAnswers.isNotEmpty ? topicAnswers.last.answeredAt : null,
    };
  }

  /// Clears all answers
  void clear() {
    _answers.clear();
  }

  /// Gets answers for a specific question ID
  List<UserAnswer> getAnswersForQuestion(int questionId) {
    return _answers.where((answer) => answer.questionId == questionId).toList();
  }

  /// Checks if a question has been answered
  bool hasAnsweredQuestion(int questionId) {
    return _answers.any((answer) => answer.questionId == questionId);
  }

  /// Gets the most recent answer for a question
  UserAnswer? getLatestAnswerForQuestion(int questionId) {
    final questionAnswers = getAnswersForQuestion(questionId);
    if (questionAnswers.isEmpty) return null;

    questionAnswers.sort((a, b) => b.answeredAt.compareTo(a.answeredAt));
    return questionAnswers.first;
  }

  /// Gets session summary
  Map<String, dynamic> getSessionSummary() {
    return {
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'incorrect_answers': totalQuestions - correctAnswers,
      'score_percentage': scorePercentage,
      'started_at': _answers.isNotEmpty ? _answers.first.answeredAt : null,
      'completed_at': _answers.isNotEmpty ? _answers.last.answeredAt : null,
      'duration_minutes': _answers.isNotEmpty
          ? _answers.last.answeredAt
              .difference(_answers.first.answeredAt)
              .inMinutes
          : 0,
    };
  }
}
