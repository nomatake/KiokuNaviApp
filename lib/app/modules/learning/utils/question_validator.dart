import '../models/models.dart';

class QuestionValidator {
  /// Validates if the selected option is correct for the given question
  static bool validateAnswer(Question question, String selectedOption) {
    return question.data.correctAnswer.selected == selectedOption;
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
    final correctKey = question.data.correctAnswer.selected;
    return question.data.options[correctKey] ?? '';
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
