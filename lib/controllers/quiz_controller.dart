import 'package:get/get.dart';
import 'package:kioku_navi/services/quiz/question_service.dart';
import 'package:kioku_navi/repositories/quiz_repository.dart';
import 'package:kioku_navi/services/quiz/answer_validator.dart';
import 'package:kioku_navi/models/question.dart';
import 'package:kioku_navi/models/quiz_session.dart';
import 'package:kioku_navi/models/quiz_config.dart';

class QuizController extends GetxController {
  final QuestionService questionService;
  final QuizRepository quizRepository;
  final AnswerValidator answerValidator;
  
  // Observable states
  final hasActiveSession = false.obs;
  final currentQuestionIndex = 0.obs;
  final totalQuestions = 0.obs;
  final currentQuestion = Rxn<Question>();
  final userAnswers = <String, dynamic>{}.obs;
  final isLoading = false.obs;
  final lastScore = 0.0.obs;
  
  // Internal state
  QuizSession? _currentSession;
  List<Question> _questions = [];
  
  QuizController({
    required this.questionService,
    required this.quizRepository,
    required this.answerValidator,
  });
  
  // Getters
  bool get canGoNext => currentQuestionIndex.value < totalQuestions.value - 1;
  bool get canGoPrevious => currentQuestionIndex.value > 0;
  bool get isCurrentQuestionAnswered => 
      currentQuestion.value != null && 
      userAnswers.containsKey(currentQuestion.value!.questionId);
  
  int get answeredCount => userAnswers.length;
  double get progress => totalQuestions.value > 0 
      ? answeredCount / totalQuestions.value 
      : 0.0;
  
  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }
  
  Future<void> _restoreSession() async {
    try {
      final savedSession = await quizRepository.getCurrentSession();
      if (savedSession != null) {
        _currentSession = savedSession;
        _questions = savedSession.questions;
        hasActiveSession.value = true;
        totalQuestions.value = _questions.length;
        userAnswers.addAll(savedSession.answers);
        _updateCurrentQuestion();
      }
    } catch (e) {
      // Failed to restore session: $e
    }
  }
  
  Future<bool> startQuiz(QuizConfig config) async {
    try {
      isLoading.value = true;
      
      // Generate quiz questions
      _questions = await questionService.generateQuiz(config);
      if (_questions.isEmpty) {
        return false;
      }
      
      // Create new session
      _currentSession = QuizSession(
        sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
        questions: _questions,
      );
      
      // Save session
      await quizRepository.saveCurrentSession(_currentSession!);
      
      // Update state
      hasActiveSession.value = true;
      totalQuestions.value = _questions.length;
      currentQuestionIndex.value = 0;
      userAnswers.clear();
      _updateCurrentQuestion();
      
      return true;
    } catch (e) {
      // Failed to start quiz: $e
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  void nextQuestion() {
    if (canGoNext) {
      currentQuestionIndex.value++;
      _updateCurrentQuestion();
    }
  }
  
  void previousQuestion() {
    if (canGoPrevious) {
      currentQuestionIndex.value--;
      _updateCurrentQuestion();
    }
  }
  
  Future<void> submitAnswer(dynamic answer) async {
    if (currentQuestion.value == null || _currentSession == null) return;
    
    try {
      isLoading.value = true;
      
      final question = currentQuestion.value!;
      final isCorrect = answerValidator.validate(
        question: question,
        userAnswer: answer,
      );
      
      // Record answer in session
      _currentSession!.recordAnswer(question.questionId, answer, isCorrect);
      userAnswers[question.questionId] = answer;
      
      // Save session
      await quizRepository.saveCurrentSession(_currentSession!);
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> completeQuiz() async {
    if (_currentSession == null) return;
    
    try {
      isLoading.value = true;
      
      // Complete the session
      _currentSession!.complete();
      
      // Calculate and store score
      lastScore.value = _currentSession!.score;
      
      // Save to permanent storage
      await quizRepository.saveSession(_currentSession!);
      await quizRepository.addToHistory(_currentSession!.sessionId);
      
      // Clear current session
      await quizRepository.clearCurrentSession();
      
      // Reset state
      hasActiveSession.value = false;
      _currentSession = null;
      _questions.clear();
      userAnswers.clear();
      currentQuestionIndex.value = 0;
      totalQuestions.value = 0;
      currentQuestion.value = null;
    } finally {
      isLoading.value = false;
    }
  }
  
  void _updateCurrentQuestion() {
    if (currentQuestionIndex.value < _questions.length) {
      currentQuestion.value = _questions[currentQuestionIndex.value];
    } else {
      currentQuestion.value = null;
    }
  }
}