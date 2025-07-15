import '../models/models.dart';

class QuestionValidator {
  /// Validates if the selected option is correct for the given question
  static bool validateAnswer(Question question, String selectedOption) {
    final questionType = question.data.questionType.toLowerCase();
    
    if (questionType.contains('matching')) {
      // For question matching, selectedOption is a map string
      // Parse the actual matching answers
      final selectedMatches = <String, String>{};
      
      // Simple parsing of the map string format: {key1: value1, key2: value2}
      if (selectedOption.startsWith('{') && selectedOption.endsWith('}')) {
        final content = selectedOption.substring(1, selectedOption.length - 1);
        final pairs = content.split(', ');
        for (final pair in pairs) {
          final parts = pair.split(': ');
          if (parts.length == 2) {
            selectedMatches[parts[0]] = parts[1];
          }
        }
      }
      
      // Get correct matches from the correct answer
      final correctAnswer = question.data.correctAnswer.selected;
      if (correctAnswer is Map<String, dynamic>) {
        final correctMatches = correctAnswer['matches'] as Map<String, dynamic>? ?? {};
        
        // Check if all matches are correct
        if (selectedMatches.length != correctMatches.length) {
          return false;
        }
        
        for (final entry in correctMatches.entries) {
          if (selectedMatches[entry.key] != entry.value) {
            return false;
          }
        }
        
        return true;
      }
      
      return false;
    } else if (question.data.correctAnswer.isMultipleSelect) {
      // For multiple select, selectedOption should be comma-separated values
      final selectedList = selectedOption.split(',').map((e) => e.trim()).toSet();
      final correctList = question.data.correctAnswer.multipleAnswers.toSet();
      return selectedList.length == correctList.length && 
             selectedList.containsAll(correctList);
    } else {
      return question.data.correctAnswer.selected == selectedOption;
    }
  }

  /// Creates a UserAnswer object for the given question and selected option
  static UserAnswer createUserAnswer(
    Question question,
    String selectedOption,
  ) {
    final isCorrect = validateAnswer(question, selectedOption);

    return UserAnswer(
      questionId: question.id,
      selectedOption: selectedOption,
      isCorrect: isCorrect,
      answeredAt: DateTime.now(),
    );
  }

  /// Gets the correct option text for a question
  static String getCorrectOptionText(Question question) {
    final questionType = question.data.questionType.toLowerCase();
    
    if (questionType.contains('matching')) {
      // For question matching, return a formatted string of correct matches
      final correctAnswer = question.data.correctAnswer.selected;
      if (correctAnswer is Map<String, dynamic>) {
        final correctMatches = correctAnswer['matches'] as Map<String, dynamic>? ?? {};
        final subQuestions = question.data.options['sub_questions'] as Map<String, dynamic>? ?? {};
        final choices = question.data.options['choices'] as Map<String, dynamic>? ?? {};
        
        return correctMatches.entries
            .map((e) => '${subQuestions[e.key] ?? e.key}: ${choices[e.value] ?? e.value}')
            .join(', ');
      }
      return '';
    } else if (question.data.correctAnswer.isMultipleSelect) {
      final correctKeys = question.data.correctAnswer.multipleAnswers;
      return correctKeys
          .map((key) => question.data.options[key]?.toString() ?? '')
          .where((text) => text.isNotEmpty)
          .join(', ');
    } else {
      final correctKey = question.data.correctAnswer.selected;
      return question.data.options[correctKey]?.toString() ?? '';
    }
  }

  /// Gets all option keys in order
  static List<String> getOptionKeys(Question question) {
    return question.data.options.keys.toList()..sort();
  }

  /// Gets all option values in the same order as keys
  static List<String> getOptionValues(Question question) {
    final keys = getOptionKeys(question);
    return keys.map((key) => question.data.options[key]?.toString() ?? '').toList();
  }
}
