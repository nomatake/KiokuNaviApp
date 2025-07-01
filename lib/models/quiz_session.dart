import 'package:kioku_navi/models/question.dart';

class QuizSession {
  final String sessionId;
  final List<Question> questions;
  final Map<String, dynamic> answers = {};
  final Map<String, bool> results = {};
  final DateTime startTime;
  DateTime? endTime;
  
  QuizSession({
    required this.sessionId,
    required this.questions,
  }) : startTime = DateTime.now();
  
  void recordAnswer(String questionId, dynamic answer, bool isCorrect) {
    answers[questionId] = answer;
    results[questionId] = isCorrect;
  }
  
  void complete() {
    endTime = DateTime.now();
  }
  
  bool get isCompleted => endTime != null;
  
  int get totalQuestions => questions.length;
  
  int get answeredQuestions => answers.length;
  
  int get correctAnswers => results.values.where((correct) => correct).length;
  
  double get score => totalQuestions > 0 
      ? (correctAnswers / totalQuestions) * 100 
      : 0;
  
  Duration get duration => (endTime ?? DateTime.now()).difference(startTime);
  
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'questions': questions.map((q) => q.toJson()).toList(),
      'answers': answers,
      'results': results,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'total_questions': totalQuestions,
      'answered_questions': answeredQuestions,
      'correct_answers': correctAnswers,
      'score': score,
      'duration_seconds': duration.inSeconds,
    };
  }
  
  factory QuizSession.fromJson(Map<String, dynamic> json) {
    final session = QuizSession(
      sessionId: json['session_id'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
    
    // Restore answers and results
    if (json['answers'] != null) {
      session.answers.addAll(json['answers'] as Map<String, dynamic>);
    }
    if (json['results'] != null) {
      (json['results'] as Map).forEach((key, value) {
        session.results[key] = value as bool;
      });
    }
    
    // Restore end time
    if (json['end_time'] != null) {
      session.endTime = DateTime.parse(json['end_time']);
    }
    
    return session;
  }
}