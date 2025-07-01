import 'package:kioku_navi/services/quiz/answer_validator.dart';
import 'package:kioku_navi/models/question.dart';

/// Implementation of answer validation for different question formats
class AnswerValidatorImpl implements AnswerValidator {
  @override
  bool validate({
    required Question question,
    required dynamic userAnswer,
  }) {
    if (userAnswer == null) return false;
    
    try {
      switch (question.format) {
        case QuestionFormat.single:
          return _validateSingleChoice(question, userAnswer);
        case QuestionFormat.multi:
          return _validateMultipleChoice(question, userAnswer);
        case QuestionFormat.numericInput:
          return _validateNumericInput(question, userAnswer);
        case QuestionFormat.sequence:
          return _validateSequence(question, userAnswer);
        case QuestionFormat.match:
          return _validateMatching(question, userAnswer);
      }
    } catch (e) {
      // In case of any validation errors, return false
      // Error validating answer: $e
      return false;
    }
  }
  
  /// Validates single choice questions where only one answer is correct
  bool _validateSingleChoice(Question question, dynamic userAnswer) {
    if (userAnswer is! String) return false;
    return userAnswer.trim() == question.answer.trim();
  }
  
  /// Validates multiple choice questions where multiple answers can be correct
  bool _validateMultipleChoice(Question question, dynamic userAnswer) {
    if (userAnswer is! List<String>) return false;
    
    // Parse correct answers from comma-separated string
    final correctAnswers = question.answer
        .split(',')
        .map((e) => e.trim())
        .toSet();
    
    // Convert user answers to set for comparison
    final userAnswerSet = userAnswer
        .map((e) => e.toString().trim())
        .toSet();
    
    // Both sets must be identical
    return correctAnswers.length == userAnswerSet.length &&
           correctAnswers.containsAll(userAnswerSet);
  }
  
  /// Validates numeric input questions
  bool _validateNumericInput(Question question, dynamic userAnswer) {
    if (userAnswer is! String) return false;
    
    // Remove spaces and compare
    final normalizedUserAnswer = userAnswer.trim();
    final normalizedCorrectAnswer = question.answer.trim();
    
    // Try to parse as numbers for more flexible comparison
    try {
      final userNum = num.parse(normalizedUserAnswer);
      final correctNum = num.parse(normalizedCorrectAnswer);
      return userNum == correctNum;
    } catch (_) {
      // Fall back to string comparison if parsing fails
      return normalizedUserAnswer == normalizedCorrectAnswer;
    }
  }
  
  /// Validates sequence questions where order matters
  bool _validateSequence(Question question, dynamic userAnswer) {
    if (userAnswer is! List<String>) return false;
    
    // Parse correct sequence from comma-separated string
    final correctSequence = question.answer
        .split(',')
        .map((e) => e.trim())
        .toList();
    
    if (userAnswer.length != correctSequence.length) return false;
    
    // Compare each element in order
    for (int i = 0; i < userAnswer.length; i++) {
      if (userAnswer[i].toString().trim() != correctSequence[i]) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Validates matching questions where items need to be paired correctly
  bool _validateMatching(Question question, dynamic userAnswer) {
    if (userAnswer is! Map<String, String>) return false;
    
    // Parse correct pairs from format "A:1,B:2,C:3"
    final correctPairs = <String, String>{};
    for (final pair in question.answer.split(',')) {
      final parts = pair.trim().split(':');
      if (parts.length == 2) {
        correctPairs[parts[0].trim()] = parts[1].trim();
      }
    }
    
    if (userAnswer.length != correctPairs.length) return false;
    
    // Check each pair matches
    for (final entry in correctPairs.entries) {
      final userValue = userAnswer[entry.key];
      if (userValue == null || userValue.trim() != entry.value) {
        return false;
      }
    }
    
    return true;
  }
}