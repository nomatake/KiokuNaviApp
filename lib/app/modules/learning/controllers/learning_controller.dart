import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/utils/navigation_args.dart';

import '../models/models.dart';
import '../services/course_api.dart';
import '../utils/progress_tracker.dart';
import '../utils/question_validator.dart';
import '../utils/session_timer.dart';

class LearningController extends BaseController {
  // Topic and questions data from API
  final Rx<Topic?> topic = Rx<Topic?>(null);
  final RxList<Question> questions = <Question>[].obs;
  
  // Topic ID from navigation
  final RxInt topicId = 0.obs;
  
  // Loading state
  final RxBool isLoadingTopic = true.obs;
  final RxString loadingError = ''.obs;

  // Current question management
  final RxInt currentQuestionIndex = 0.obs;
  Question? get currentQuestion =>
      questions.isNotEmpty ? questions[currentQuestionIndex.value] : null;

  // Answer selection state
  final RxInt selectedOptionIndex = (-1).obs;
  final RxBool hasSubmitted = false.obs;
  final RxBool isCorrect = false.obs;
  
  // For fill-in-the-blank questions
  final RxString userTextAnswer = ''.obs;
  
  // For multiple select questions
  final RxList<String> selectedMultipleOptions = <String>[].obs;
  
  // For question matching
  final RxMap<String, String> matchingAnswers = <String, String>{}.obs;
  final RxString activeMatchingQuestion = ''.obs;
  
  // For ordering questions
  final RxList<String?> orderingAnswers = <String?>[].obs;
  final RxInt dragHoverPosition = (-1).obs;
  final RxString draggedOptionKey = ''.obs;

  // Progress tracking
  final ProgressTracker progressTracker = ProgressTracker();
  final RxList<UserAnswer> sessionAnswers = <UserAnswer>[].obs;
  
  // Timer tracking
  final SessionTimer sessionTimer = SessionTimer();

  // Question flow state
  bool get hasMoreQuestions =>
      currentQuestionIndex.value < questions.length - 1;
  bool get isLastQuestion => currentQuestionIndex.value == questions.length - 1;
  int get totalQuestions => questions.length;
  int get questionNumber => currentQuestionIndex.value + 1;
  
  // UI state
  bool get shouldShowAppBar => 
      !isLoadingTopic.value && 
      loadingError.value.isEmpty && 
      questions.isNotEmpty;
  
  // Course API service
  late final CourseApi _courseApi;

  @override
  void onInit() {
    super.onInit();
    _courseApi = Get.find<CourseApi>();
    _extractTopicId();
    _loadTopicData();
  }

  /// Extract topic ID from navigation arguments
  void _extractTopicId() {
    try {
      final navArgs = NavigationArgs.current();
      final id = navArgs.getInt('topicId');
      
      if (id > 0) {
        topicId.value = id;
      } else {
        loadingError.value = 'No topic ID provided';
        isLoadingTopic.value = false;
      }
    } catch (e) {
      loadingError.value = 'Error extracting topic ID: $e';
      isLoadingTopic.value = false;
    }
  }

  /// Load topic data from API
  Future<void> _loadTopicData() async {
    if (topicId.value == 0) {
      return;
    }
    
    try {
      isLoadingTopic.value = true;
      loadingError.value = '';
      
      // Make API call to get topic with questions
      final response = await _courseApi.getTopicWithQuestions(topicId.value);
      
      // Parse the response to get Topic model
      final responseData = response['data'] as Map<String, dynamic>;
      topic.value = Topic.fromJson(responseData);
      
      // Extract questions from content blocks
      if (topic.value != null && topic.value!.contentBlocks != null) {
        questions.assignAll(topic.value!.contentBlocks!);
        
        // Initialize first question
        if (questions.isNotEmpty) {
          _initializeQuestion();
        }
      }
      
      isLoadingTopic.value = false;
    } catch (e) {
      loadingError.value = 'Failed to load topic: $e';
      isLoadingTopic.value = false;
    }
  }

  /// Initialize current question state
  void _initializeQuestion() {
    selectedOptionIndex.value = -1;
    hasSubmitted.value = false;
    isCorrect.value = false;
    userTextAnswer.value = '';
    selectedMultipleOptions.clear();
    matchingAnswers.clear();
    activeMatchingQuestion.value = '';
    orderingAnswers.clear();
    dragHoverPosition.value = -1;
    draggedOptionKey.value = '';
    
    // Start timer for the new question
    sessionTimer.resetCurrentItem();
    sessionTimer.start();
  }

  /// Get options for current question
  List<String> get currentOptions {
    if (currentQuestion == null) return [];

    final options = currentQuestion!.data.options;
    final questionType = currentQuestion!.data.questionType.toLowerCase();
    
    // For question matching, options are structured differently
    if (questionType.contains('matching')) {
      return [];
    }
    
    final sortedKeys = options.keys.toList()..sort();
    return sortedKeys.map((key) => options[key]?.toString() ?? '').toList();
  }

  /// Get option keys in sorted order
  List<String> get currentOptionKeys {
    if (currentQuestion == null) return [];

    final options = currentQuestion!.data.options;
    return options.keys.toList()..sort();
  }

  /// Get current question text
  String get currentQuestionText {
    return currentQuestion?.data.question ?? '';
  }

  /// Select an answer option
  void selectOption(int index) {
    if (!hasSubmitted.value && index >= 0 && index < currentOptionKeys.length) {
      selectedOptionIndex.value = index;
    }
  }
  
  /// Toggle a multiple select option
  void toggleMultipleOption(String optionKey) {
    if (!hasSubmitted.value) {
      if (selectedMultipleOptions.contains(optionKey)) {
        selectedMultipleOptions.remove(optionKey);
      } else {
        selectedMultipleOptions.add(optionKey);
      }
      // Update selectedOptionIndex to indicate if any options are selected
      selectedOptionIndex.value = selectedMultipleOptions.isNotEmpty ? 0 : -1;
    }
  }
  
  /// Set text answer for fill-in-the-blank questions
  void setTextAnswer(String answer) {
    if (!hasSubmitted.value) {
      userTextAnswer.value = answer;
      // Set selectedOptionIndex to indicate an answer exists
      selectedOptionIndex.value = answer.isNotEmpty ? 0 : -1;
    }
  }
  
  /// Set matching answer for question matching
  void setMatchingAnswer(String questionKey, String choiceKey) {
    if (!hasSubmitted.value) {
      matchingAnswers[questionKey] = choiceKey;
      // Check if all questions have been answered
      final subQuestions = currentQuestion?.data.options['sub_questions'] as Map<String, dynamic>?;
      if (subQuestions != null) {
        final allAnswered = subQuestions.keys.every((key) => matchingAnswers.containsKey(key));
        selectedOptionIndex.value = allAnswered ? 0 : -1;
      }
    }
  }
  

  /// Submit the current answer
  void submitAnswer() {
    if (selectedOptionIndex.value == -1 ||
        hasSubmitted.value ||
        currentQuestion == null) {
      return;
    }

    hasSubmitted.value = true;
    
    // Pause the timer when answer is submitted
    sessionTimer.pause();
    sessionTimer.nextItem();
    
    String selectedAnswer;
    
    // Check question type and get appropriate answer
    final questionType = currentQuestion!.data.questionType.toLowerCase();
    
    if (questionType.contains('multiple_select') || 
        questionType.contains('multiple-select')) {
      // For multiple select, join selected options with comma
      selectedAnswer = selectedMultipleOptions.join(',');
    } else if (questionType.contains('fill') || 
               questionType.contains('blank')) {
      // Use text answer for fill-in-the-blank
      selectedAnswer = userTextAnswer.value.trim();
    } else if (questionType.contains('matching')) {
      // For question matching, convert map to JSON string
      selectedAnswer = matchingAnswers.toString();
    } else if (questionType.contains('ordering')) {
      // For ordering questions, create position map similar to correct answer format
      final orderMap = <String, String>{};
      for (int i = 0; i < orderingAnswers.length; i++) {
        orderMap['position_${i + 1}'] = orderingAnswers[i]!;
      }
      selectedAnswer = orderMap.toString();
    } else {
      // Get the selected option key for multiple choice/true-false
      selectedAnswer = currentOptionKeys[selectedOptionIndex.value];
    }

    // Validate answer and create UserAnswer
    final userAnswer = QuestionValidator.createUserAnswer(
      currentQuestion!,
      selectedAnswer,
    );

    // Update states
    isCorrect.value = userAnswer.isCorrect;

    // Track the answer
    progressTracker.addAnswer(userAnswer);
    sessionAnswers.add(userAnswer);
  }

  /// Move to next question or finish
  void nextQuestion() {
    if (!hasSubmitted.value) return;

    if (hasMoreQuestions) {
      // Move to next question
      currentQuestionIndex.value++;
      _initializeQuestion();
    } else {
      // Finish the topic and go to results
      _finishTopic();
    }
  }

  /// Finish the topic and navigate to results
  void _finishTopic() {
    // Stop the timer
    sessionTimer.stop();

    // Navigate to results - no need to pass data since ResultView uses the same controller
    Get.toNamed(Routes.RESULT);
  }

  /// Get the correct answer index for UI highlighting
  int get correctAnswerIndex {
    if (currentQuestion == null) return -1;
    
    if (currentQuestion!.data.correctAnswer.isMultipleSelect) {
      // For multiple select, return -1 as there's no single correct index
      return -1;
    }

    final correctKey = currentQuestion!.data.correctAnswer.selected;
    final optionKeys = currentOptionKeys;

    return optionKeys.indexOf(correctKey);
  }
  
  /// Get correct answer indices for multiple select questions
  List<int> get correctAnswerIndices {
    if (currentQuestion == null || 
        !currentQuestion!.data.correctAnswer.isMultipleSelect) {
      return [];
    }
    
    final correctKeys = currentQuestion!.data.correctAnswer.multipleAnswers;
    final optionKeys = currentOptionKeys;
    
    return correctKeys
        .map((key) => optionKeys.indexOf(key))
        .where((index) => index != -1)
        .toList();
  }

  /// Get current progress as percentage
  double get progressPercentage {
    if (totalQuestions == 0) return 0.0;
    return (questionNumber / totalQuestions).clamp(0.0, 1.0);
  }

  /// Get session statistics
  Map<String, dynamic> get sessionStats {
    return {
      'currentQuestion': questionNumber,
      'totalQuestions': totalQuestions,
      'correctAnswers': progressTracker.correctAnswers,
      'scorePercentage': progressTracker.scorePercentage,
      'topicTitle': topic.value?.title ?? '',
    };
  }

  /// Get formatted time string (delegate to timer)
  String get formattedTotalTime => sessionTimer.formattedTotalTime;
  
  /// Get average time per question (delegate to timer)
  double get averageTimePerQuestion => sessionTimer.averageTimePerItem;

  @override
  void onClose() {
    sessionTimer.dispose();
    super.onClose();
  }
}
