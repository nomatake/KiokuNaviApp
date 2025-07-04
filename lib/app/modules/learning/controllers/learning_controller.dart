import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/utils/navigation_helper.dart';

class LearningController extends BaseController {
  // Current selected option index (-1 means no selection)
  final RxInt selectedOptionIndex = (-1).obs;

  // Whether the answer has been submitted
  final RxBool hasSubmitted = false.obs;

  // Whether the selected answer is correct
  final RxBool isCorrect = false.obs;

  // The correct answer index (for demo, let's say option 0 is correct)
  final int correctAnswerIndex = 0;

  // Answer options
  final List<String> options = [
    '物事に興味を抱くこと',
    '心に深く感ずること',
    '相手に気に入られる心',
  ];

  void selectOption(int index) {
    if (!hasSubmitted.value) {
      selectedOptionIndex.value = index;
    }
  }

  void submitAnswer() {
    if (selectedOptionIndex.value != -1 && !hasSubmitted.value) {
      hasSubmitted.value = true;
      isCorrect.value = selectedOptionIndex.value == correctAnswerIndex;
    }
  }

  void nextQuestion() {
    if (hasSubmitted.value) {
      if (isCorrect.value) {
        // Request navigation to result using helper
        requestNavigation(Routes.RESULT);
      } else {
        // Reset for retry or show error
        resetQuestion();
      }
    }
  }

  void resetQuestion() {
    selectedOptionIndex.value = -1;
    hasSubmitted.value = false;
    isCorrect.value = false;
  }
}
