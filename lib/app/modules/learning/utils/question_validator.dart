import '../models/models.dart';

class QuestionValidator {
  /// Validates if the selected option is correct for the given question
  static bool validateAnswer(Question question, String selectedOption) {
    if (question.data.correctAnswer.isMultipleSelect) {
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
    if (question.data.correctAnswer.isMultipleSelect) {
      final correctKeys = question.data.correctAnswer.multipleAnswers;
      return correctKeys
          .map((key) => question.data.options[key] ?? '')
          .where((text) => text.isNotEmpty)
          .join(', ');
    } else {
      final correctKey = question.data.correctAnswer.selected;
      return question.data.options[correctKey] ?? '';
    }
  }

  /// Gets all option keys in order
  static List<String> getOptionKeys(Question question) {
    return question.data.options.keys.toList()..sort();
  }

  /// Gets all option values in the same order as keys
  static List<String> getOptionValues(Question question) {
    final keys = getOptionKeys(question);
    return keys.map((key) => question.data.options[key] ?? '').toList();
  }
}
