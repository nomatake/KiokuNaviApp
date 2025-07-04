# 🎛️ BaseController Usage Guide - KiokuNaviApp

**Version**: 1.0  
**Date**: 2025-07-04  
**Author**: Phase 3 Optimization Implementation  

---

## 📋 Overview

This guide provides comprehensive examples and best practices for using the BaseController system implemented in Phase 3 optimization. The BaseController establishes a standardized foundation for all controllers in the KiokuNaviApp, providing error handling, loading states, and navigation patterns.

---

## 🌟 Key Features

### **Standardized Controller Architecture**
- ✅ **Error handling** with automatic user feedback
- ✅ **Loading state management** with reactive observables
- ✅ **Safe API call patterns** for future integrations
- ✅ **Navigation helper integration** for proper GetX patterns
- ✅ **Consistent lifecycle management**
- ✅ **Debug logging** for development

### **Built-in Reactive States**
- ✅ **`isLoading`** - RxBool for loading indicators
- ✅ **`error`** - RxString for error messages
- ✅ **`hasError`** - RxBool for error state tracking
- ✅ **Navigation callbacks** for proper separation of concerns

---

## 🚀 Quick Start

### **Extend BaseController**

```dart
import 'package:kioku_navi/controllers/base_controller.dart';

class MyController extends BaseController {
  // Your controller implementation
}
```

### **Basic Usage**

```dart
class AuthController extends BaseController {
  void login() {
    safeCall(() async {
      // Your async operation
      await performLogin();
    }, errorMessage: 'ログインに失敗しました');
  }
}
```

---

## 🔧 Detailed Usage Examples

### **1. Basic Controller Implementation**

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';

class AuthController extends BaseController {
  // Form controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  
  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  
  // Observable states (additional to BaseController states)
  final RxBool isPasswordVisible = false.obs;
  final RxBool rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controller-specific logic
    _setupValidation();
  }

  @override
  void onReady() {
    super.onReady();
    // Controller is ready - setup navigation
    setupNavigation();
  }

  @override
  void onClose() {
    // Cleanup resources
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose(); // This calls clearNavigation() from BaseController
  }

  void _setupValidation() {
    // Setup real-time validation if needed
    email.addListener(_validateEmail);
    password.addListener(_validatePassword);
  }

  void _validateEmail() {
    if (hasError.value && email.text.isNotEmpty) {
      clearError(); // Clear errors when user starts fixing input
    }
  }

  void _validatePassword() {
    if (hasError.value && password.text.isNotEmpty) {
      clearError();
    }
  }
}
```

### **2. Login Implementation with Error Handling**

```dart
// Login method with comprehensive error handling
void login() {
  safeCall(() async {
    // Validate form
    if (!loginFormKey.currentState!.validate()) {
      throw 'すべての必須項目を入力してください';
    }

    // Check email format
    if (!_isValidEmail(email.text)) {
      throw 'メールアドレスの形式が正しくありません';
    }

    // Check password length
    if (password.text.length < 6) {
      throw 'パスワードは6文字以上で入力してください';
    }

    // Simulate API call (replace with actual implementation)
    await _performLogin(email.text, password.text);

    // Success - navigate to home
    requestNavigation(Routes.HOME);

  }, errorMessage: 'ログインに失敗しました。認証情報を確認してください。');
}

// Registration method
void register() {
  safeCall(() async {
    // Validate registration form
    if (!registerFormKey.currentState!.validate()) {
      throw 'すべての必須項目を正しく入力してください';
    }

    // Check password confirmation
    if (password.text != confirmPassword.text) {
      throw 'パスワードが一致しません';
    }

    // Check password strength
    if (!_isStrongPassword(password.text)) {
      throw 'パスワードは8文字以上で、大文字、小文字、数字を含む必要があります';
    }

    // Simulate registration
    await _performRegistration(email.text, password.text);

    // Success - navigate to tutorial
    requestNavigation(Routes.TUTORIAL);

  }, errorMessage: 'ユーザー登録に失敗しました。もう一度お試しください。');
}

// Helper methods
bool _isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

bool _isStrongPassword(String password) {
  return password.length >= 8 &&
         RegExp(r'[A-Z]').hasMatch(password) &&
         RegExp(r'[a-z]').hasMatch(password) &&
         RegExp(r'[0-9]').hasMatch(password);
}

Future<void> _performLogin(String email, String password) async {
  // Simulate network delay
  await Future.delayed(Duration(seconds: 2));
  
  // Simulate login validation
  if (email.isEmpty || password.isEmpty) {
    throw 'メールアドレスとパスワードを入力してください';
  }
  
  // TODO: Replace with actual API call
  print('Login successful for: $email');
}

Future<void> _performRegistration(String email, String password) async {
  // Simulate network delay
  await Future.delayed(Duration(seconds: 3));
  
  // TODO: Replace with actual API call
  print('Registration successful for: $email');
}
```

### **3. Course Management with BaseController**

```dart
class CourseController extends BaseController {
  // Observable course data
  final RxList<Course> courses = <Course>[].obs;
  final RxList<Lesson> currentLessons = <Lesson>[].obs;
  final Rx<Course?> selectedCourse = Rx<Course?>(null);
  
  // Progress tracking
  final RxDouble overallProgress = 0.0.obs;
  final RxInt completedLessons = 0.obs;
  final RxInt totalLessons = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCourses();
  }

  @override
  void onReady() {
    super.onReady();
    setupNavigation();
  }

  // Load courses with error handling
  void loadCourses() {
    safeApiCall(() async {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      final loadedCourses = await _fetchCourses();
      courses.assignAll(loadedCourses);
      
      if (courses.isNotEmpty) {
        selectCourse(courses.first);
      }
      
      return courses;
      
    }).then((result) {
      if (result != null) {
        print('Courses loaded successfully: ${result.length} courses');
      }
    });
  }

  // Select course and load lessons
  void selectCourse(Course course) {
    safeCall(() async {
      selectedCourse.value = course;
      
      // Load lessons for selected course
      final lessons = await _fetchLessonsForCourse(course.id);
      currentLessons.assignAll(lessons);
      
      // Calculate progress
      _calculateProgress();
      
    }, errorMessage: 'コースの読み込みに失敗しました');
  }

  // Start a lesson
  void startLesson(Lesson lesson) {
    safeCall(() async {
      // Check if lesson is unlocked
      if (!_isLessonUnlocked(lesson)) {
        throw '前のレッスンを完了してください';
      }

      // Mark lesson as started
      lesson.status = LessonStatus.inProgress;
      currentLessons.refresh();

      // Navigate to lesson
      requestNavigation('${Routes.LESSON}?id=${lesson.id}');

    }, errorMessage: 'レッスンの開始に失敗しました');
  }

  // Complete a lesson
  void completeLesson(String lessonId, double score) {
    safeCall(() async {
      final lessonIndex = currentLessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex == -1) {
        throw 'レッスンが見つかりません';
      }

      final lesson = currentLessons[lessonIndex];
      lesson.status = LessonStatus.completed;
      lesson.score = score;
      lesson.completedAt = DateTime.now();

      // Update progress
      completedLessons.value++;
      _calculateProgress();

      // Save progress (simulate API call)
      await _saveProgress(lessonId, score);

      // Navigate to results
      requestNavigation('${Routes.LESSON_RESULT}?score=$score');

    }, errorMessage: 'レッスンの完了処理に失敗しました');
  }

  // Reset course progress
  void resetProgress() {
    safeCall(() async {
      if (selectedCourse.value == null) {
        throw 'コースが選択されていません';
      }

      // Confirm reset
      final confirmed = await _confirmReset();
      if (!confirmed) return;

      // Reset all lessons
      for (var lesson in currentLessons) {
        lesson.status = LessonStatus.locked;
        lesson.score = 0.0;
        lesson.completedAt = null;
      }

      // Unlock first lesson
      if (currentLessons.isNotEmpty) {
        currentLessons.first.status = LessonStatus.available;
      }

      completedLessons.value = 0;
      overallProgress.value = 0.0;
      currentLessons.refresh();

      // Save reset state
      await _saveResetProgress();

    }, errorMessage: '進捗のリセットに失敗しました');
  }

  // Helper methods
  Future<List<Course>> _fetchCourses() async {
    // Simulate API call
    return [
      Course(id: '1', title: '基礎コース', description: '基本的な学習内容'),
      Course(id: '2', title: '応用コース', description: '応用的な学習内容'),
      Course(id: '3', title: '実践コース', description: '実践的な学習内容'),
    ];
  }

  Future<List<Lesson>> _fetchLessonsForCourse(String courseId) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    
    return List.generate(10, (index) => Lesson(
      id: '${courseId}_lesson_$index',
      title: 'レッスン ${index + 1}',
      description: 'レッスン ${index + 1} の説明',
      status: index == 0 ? LessonStatus.available : LessonStatus.locked,
    ));
  }

  bool _isLessonUnlocked(Lesson lesson) {
    return lesson.status == LessonStatus.available || 
           lesson.status == LessonStatus.inProgress ||
           lesson.status == LessonStatus.completed;
  }

  void _calculateProgress() {
    if (totalLessons.value > 0) {
      overallProgress.value = completedLessons.value / totalLessons.value;
    }
  }

  Future<void> _saveProgress(String lessonId, double score) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    print('Progress saved: $lessonId - $score');
  }

  Future<bool> _confirmReset() async {
    // Show confirmation dialog
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text('進捗をリセット'),
        content: Text('すべての進捗が削除されます。よろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('リセット'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _saveResetProgress() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    print('Progress reset saved');
  }
}

// Data models
class Course {
  final String id;
  final String title;
  final String description;

  Course({required this.id, required this.title, required this.description});
}

class Lesson {
  final String id;
  final String title;
  final String description;
  LessonStatus status;
  double score;
  DateTime? completedAt;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.status = LessonStatus.locked,
    this.score = 0.0,
    this.completedAt,
  });
}

enum LessonStatus {
  locked,
  available,
  inProgress,
  completed,
}
```

### **4. Tutorial Controller with Navigation**

```dart
class TutorialController extends BaseController {
  // Tutorial state
  final RxInt currentStep = 1.obs;
  final RxInt totalSteps = 9.obs;
  final RxBool canProceed = true.obs;
  final RxBool hasCompletedTutorial = false.obs;

  // Tutorial data
  final RxList<TutorialStep> steps = <TutorialStep>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeTutorialSteps();
  }

  @override
  void onReady() {
    super.onReady();
    setupNavigation();
    _checkTutorialCompletion();
  }

  // Initialize tutorial steps
  void _initializeTutorialSteps() {
    steps.assignAll([
      TutorialStep(
        id: 1,
        title: 'ようこそ',
        message: 'KiokuNaviへようこそ！一緒に学習を始めましょう。',
        type: TutorialStepType.welcome,
      ),
      TutorialStep(
        id: 2,
        title: 'ナビゲーション',
        message: '画面下のナビゲーションバーで移動できます。',
        type: TutorialStepType.navigation,
      ),
      TutorialStep(
        id: 3,
        title: 'コース選択',
        message: '学習したいコースを選択してください。',
        type: TutorialStepType.courseSelection,
      ),
      // Add more steps as needed
    ]);
    
    totalSteps.value = steps.length;
  }

  // Navigate to next step
  void nextStep() {
    safeCall(() async {
      if (!canProceed.value) {
        throw '現在のステップを完了してください';
      }

      if (currentStep.value >= totalSteps.value) {
        // Tutorial completed
        await _completeTutorial();
        return;
      }

      // Move to next step
      currentStep.value++;
      await _saveProgress();

      // Navigate to next tutorial view
      final nextRoute = '${Routes.TUTORIAL}_${currentStep.value}';
      requestNavigation(nextRoute);

    }, errorMessage: '次のステップに進めませんでした');
  }

  // Navigate to previous step
  void previousStep() {
    safeCall(() async {
      if (currentStep.value <= 1) {
        throw '最初のステップです';
      }

      currentStep.value--;
      await _saveProgress();

      // Navigate to previous tutorial view
      final previousRoute = '${Routes.TUTORIAL}_${currentStep.value}';
      requestNavigation(previousRoute);

    }, errorMessage: '前のステップに戻れませんでした');
  }

  // Skip tutorial
  void skipTutorial() {
    safeCall(() async {
      final confirmed = await _confirmSkip();
      if (!confirmed) return;

      await _completeTutorial();

    }, errorMessage: 'チュートリアルのスキップに失敗しました');
  }

  // Complete current step
  void completeCurrentStep() {
    safeCall(() async {
      final currentStepData = steps.firstWhere(
        (step) => step.id == currentStep.value,
        orElse: () => throw 'ステップが見つかりません',
      );

      // Mark step as completed
      currentStepData.isCompleted = true;
      canProceed.value = true;

      // Perform step-specific actions
      await _performStepAction(currentStepData);

      // Auto-advance for certain step types
      if (currentStepData.type == TutorialStepType.automatic) {
        await Future.delayed(Duration(seconds: 2));
        nextStep();
      }

    }, errorMessage: 'ステップの完了に失敗しました');
  }

  // Reset tutorial
  void resetTutorial() {
    safeCall(() async {
      final confirmed = await _confirmReset();
      if (!confirmed) return;

      currentStep.value = 1;
      hasCompletedTutorial.value = false;
      canProceed.value = true;

      // Reset all steps
      for (var step in steps) {
        step.isCompleted = false;
      }

      await _saveProgress();
      requestNavigation('${Routes.TUTORIAL}_1');

    }, errorMessage: 'チュートリアルのリセットに失敗しました');
  }

  // Helper methods
  void _checkTutorialCompletion() {
    // Check if tutorial was previously completed
    // This would typically check local storage or user preferences
    hasCompletedTutorial.value = false; // Implement your logic
  }

  Future<void> _completeTutorial() async {
    hasCompletedTutorial.value = true;
    await _saveProgress();
    
    // Navigate to main app
    requestNavigation(Routes.HOME);
  }

  Future<void> _saveProgress() async {
    // Simulate saving tutorial progress
    await Future.delayed(Duration(milliseconds: 500));
    print('Tutorial progress saved: Step ${currentStep.value}');
  }

  Future<bool> _confirmSkip() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text('チュートリアルをスキップ'),
        content: Text('チュートリアルをスキップしますか？後で設定から再度見ることができます。'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('続ける'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('スキップ'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _confirmReset() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text('チュートリアルをリセット'),
        content: Text('チュートリアルを最初からやり直しますか？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('リセット'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _performStepAction(TutorialStep step) async {
    switch (step.type) {
      case TutorialStepType.welcome:
        // Welcome step action
        break;
      case TutorialStepType.navigation:
        // Show navigation hints
        break;
      case TutorialStepType.courseSelection:
        // Highlight course selection
        break;
      case TutorialStepType.automatic:
        // Automatic progression
        break;
    }
  }
}

// Tutorial data models
class TutorialStep {
  final int id;
  final String title;
  final String message;
  final TutorialStepType type;
  bool isCompleted;

  TutorialStep({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.isCompleted = false,
  });
}

enum TutorialStepType {
  welcome,
  navigation,
  courseSelection,
  automatic,
}
```

### **5. Learning Controller with Progress Tracking**

```dart
class LearningController extends BaseController {
  // Question state
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt selectedOptionIndex = (-1).obs;
  final RxBool hasSubmitted = false.obs;
  final RxBool isCorrect = false.obs;
  
  // Session state
  final RxList<Question> questions = <Question>[].obs;
  final RxList<UserAnswer> userAnswers = <UserAnswer>[].obs;
  final RxInt score = 0.obs;
  final RxInt totalQuestions = 0.obs;
  final RxDouble sessionProgress = 0.0.obs;

  // Timer (if needed)
  final RxInt timeRemaining = 0.obs;
  Timer? _sessionTimer;

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  @override
  void onReady() {
    super.onReady();
    setupNavigation();
  }

  @override
  void onClose() {
    _sessionTimer?.cancel();
    super.onClose();
  }

  // Load questions for current session
  void loadQuestions() {
    safeApiCall(() async {
      final loadedQuestions = await _fetchQuestions();
      questions.assignAll(loadedQuestions);
      totalQuestions.value = questions.length;
      
      if (questions.isNotEmpty) {
        _startSession();
      }
      
      return questions;
      
    }).then((result) {
      if (result != null && result.isEmpty) {
        handleError('質問が見つかりませんでした', customMessage: 'セッションを開始できません');
      }
    });
  }

  // Start learning session
  void _startSession() {
    currentQuestionIndex.value = 0;
    userAnswers.clear();
    score.value = 0;
    sessionProgress.value = 0.0;
    
    // Start timer if needed
    timeRemaining.value = 1800; // 30 minutes
    _startTimer();
  }

  // Select an answer option
  void selectOption(int index) {
    safeCall(() async {
      if (hasSubmitted.value) {
        throw 'すでに回答を送信済みです';
      }

      if (index < 0 || index >= currentQuestion.options.length) {
        throw '無効な選択肢です';
      }

      selectedOptionIndex.value = index;

    }, errorMessage: '選択肢の選択に失敗しました');
  }

  // Submit current answer
  void submitAnswer() {
    safeCall(() async {
      if (selectedOptionIndex.value == -1) {
        throw '選択肢を選んでください';
      }

      if (hasSubmitted.value) {
        throw 'すでに回答済みです';
      }

      final question = currentQuestion;
      final isAnswerCorrect = selectedOptionIndex.value == question.correctAnswerIndex;
      
      // Record user answer
      final userAnswer = UserAnswer(
        questionId: question.id,
        selectedIndex: selectedOptionIndex.value,
        isCorrect: isAnswerCorrect,
        timeSpent: _calculateTimeSpent(),
      );
      
      userAnswers.add(userAnswer);
      
      // Update state
      hasSubmitted.value = true;
      isCorrect.value = isAnswerCorrect;
      
      if (isAnswerCorrect) {
        score.value++;
      }
      
      // Update progress
      sessionProgress.value = (currentQuestionIndex.value + 1) / totalQuestions.value;

    }, errorMessage: '回答の送信に失敗しました');
  }

  // Move to next question
  void nextQuestion() {
    safeCall(() async {
      if (!hasSubmitted.value) {
        throw '回答を送信してください';
      }

      if (currentQuestionIndex.value >= questions.length - 1) {
        // Session completed
        await _completeSession();
        return;
      }

      // Move to next question
      currentQuestionIndex.value++;
      selectedOptionIndex.value = -1;
      hasSubmitted.value = false;
      isCorrect.value = false;

    }, errorMessage: '次の質問に進めませんでした');
  }

  // Skip current question
  void skipQuestion() {
    safeCall(() async {
      if (hasSubmitted.value) {
        throw 'すでに回答済みです';
      }

      // Record as skipped
      final userAnswer = UserAnswer(
        questionId: currentQuestion.id,
        selectedIndex: -1,
        isCorrect: false,
        timeSpent: _calculateTimeSpent(),
        isSkipped: true,
      );
      
      userAnswers.add(userAnswer);
      
      // Move to next question
      hasSubmitted.value = true;
      isCorrect.value = false;
      sessionProgress.value = (currentQuestionIndex.value + 1) / totalQuestions.value;

    }, errorMessage: '質問のスキップに失敗しました');
  }

  // Complete learning session
  Future<void> _completeSession() async {
    _sessionTimer?.cancel();
    
    // Calculate final results
    final finalScore = score.value;
    final accuracy = totalQuestions.value > 0 ? (finalScore / totalQuestions.value) * 100 : 0.0;
    
    // Save session results
    await _saveSessionResults(finalScore, accuracy);
    
    // Navigate to results
    requestNavigation('${Routes.LEARNING_RESULT}?score=$finalScore&accuracy=${accuracy.toInt()}');
  }

  // Restart session
  void restartSession() {
    safeCall(() async {
      final confirmed = await _confirmRestart();
      if (!confirmed) return;

      // Reset all state
      currentQuestionIndex.value = 0;
      selectedOptionIndex.value = -1;
      hasSubmitted.value = false;
      isCorrect.value = false;
      userAnswers.clear();
      score.value = 0;
      sessionProgress.value = 0.0;
      
      _startSession();

    }, errorMessage: 'セッションの再開に失敗しました');
  }

  // Helper methods
  Question get currentQuestion {
    if (questions.isEmpty || currentQuestionIndex.value >= questions.length) {
      throw 'Current question not available';
    }
    return questions[currentQuestionIndex.value];
  }

  void _startTimer() {
    _sessionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        // Time's up
        timer.cancel();
        safeCall(() async {
          await _completeSession();
        }, errorMessage: '時間切れによるセッション終了に失敗しました');
      }
    });
  }

  int _calculateTimeSpent() {
    // Calculate time spent on current question
    // This would track from when question was shown
    return 30; // Placeholder
  }

  Future<List<Question>> _fetchQuestions() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    
    return [
      Question(
        id: '1',
        text: '「関心」の意味として最も適切なものはどれですか？',
        options: [
          '物事に興味を抱くこと',
          '心に深く感ずること',
          '相手に気に入られる心',
          '注意深く見守ること',
        ],
        correctAnswerIndex: 0,
      ),
      // Add more questions
    ];
  }

  Future<void> _saveSessionResults(int score, double accuracy) async {
    // Simulate API call to save results
    await Future.delayed(Duration(seconds: 1));
    print('Session results saved: Score=$score, Accuracy=$accuracy%');
  }

  Future<bool> _confirmRestart() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text('セッションを再開'),
        content: Text('現在の進捗は失われます。セッションを最初からやり直しますか？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('再開'),
          ),
        ],
      ),
    ) ?? false;
  }
}

// Data models
class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class UserAnswer {
  final String questionId;
  final int selectedIndex;
  final bool isCorrect;
  final int timeSpent;
  final bool isSkipped;

  UserAnswer({
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
    required this.timeSpent,
    this.isSkipped = false,
  });
}
```

### **6. UI Integration with BaseController**

```dart
// Example view showing how to integrate with BaseController
class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Loading overlay
                Obx(() => controller.isLoading.value
                  ? Container(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: AppSpacing.sm),
                          Text('ログイン中...'),
                        ],
                      ),
                    )
                  : SizedBox.shrink()),

                // Error display
                Obx(() => controller.hasError.value
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.md),
                      margin: EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade300),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              controller.error.value,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: controller.clearError,
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink()),

                // Email field
                CustomTextFormField(
                  textController: controller.email,
                  labelText: 'メールアドレス',
                  keyboardType: TextInputType.emailAddress,
                  customValidators: [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ],
                ),

                SizedBox(height: AppSpacing.md),

                // Password field
                CustomTextFormField(
                  textController: controller.password,
                  labelText: 'パスワード',
                  isPassword: true,
                  customValidators: [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ],
                ),

                SizedBox(height: AppSpacing.lg),

                // Login button
                Obx(() => CustomButton.primary(
                  text: 'ログイン',
                  onPressed: controller.isLoading.value ? null : controller.login,
                )),

                SizedBox(height: AppSpacing.md),

                // Register button
                CustomButton.secondary(
                  text: 'アカウント作成',
                  onPressed: () => controller.requestNavigation(Routes.REGISTER),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🎯 BaseController Methods Reference

### **Error Handling Methods**

```dart
// Safe API call with automatic loading and error handling
Future<T?> safeApiCall<T>(Future<T> Function() apiCall)

// Safe call with custom error message
Future<T?> safeCall<T>(Future<T> Function() call, {String? errorMessage})

// Manual error handling
void handleError(dynamic error, {String? customMessage})

// Clear current error
void clearError()

// Show/hide loading states
void showLoading()
void hideLoading()
```

### **Navigation Methods (from NavigationHelper)**

```dart
// Request navigation (callback pattern)
void requestNavigation(String route)

// Setup navigation callback (usually in onReady)
void setupNavigation()

// Clear navigation callback (called in onClose)
void clearNavigation()
```

### **Observable States**

```dart
// Available reactive states
final RxBool isLoading;   // Loading state
final RxString error;     // Error message
final RxBool hasError;    // Error state flag
```

---

## 🧪 Testing BaseController

### **Unit Testing Example**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/controllers/base_controller.dart';

class TestController extends BaseController {
  void testSafeCall() {
    safeCall(() async {
      await Future.delayed(Duration(milliseconds: 100));
      throw 'Test error';
    }, errorMessage: 'Custom error message');
  }

  void testSafeApiCall() {
    safeApiCall(() async {
      await Future.delayed(Duration(milliseconds: 100));
      return 'Success result';
    });
  }
}

void main() {
  group('BaseController Tests', () {
    late TestController controller;

    setUp(() {
      Get.testMode = true;
      controller = TestController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('should handle errors in safeCall', () async {
      expect(controller.hasError.value, false);
      expect(controller.error.value, '');

      controller.testSafeCall();
      
      // Wait for async operation
      await Future.delayed(Duration(milliseconds: 200));

      expect(controller.hasError.value, true);
      expect(controller.error.value, 'Custom error message');
    });

    test('should manage loading state in safeApiCall', () async {
      expect(controller.isLoading.value, false);

      controller.testSafeApiCall();
      
      // Should be loading immediately
      expect(controller.isLoading.value, true);

      // Wait for completion
      await Future.delayed(Duration(milliseconds: 200));

      expect(controller.isLoading.value, false);
    });

    test('should clear errors', () async {
      // Trigger error
      controller.testSafeCall();
      await Future.delayed(Duration(milliseconds: 200));
      
      expect(controller.hasError.value, true);
      
      // Clear error
      controller.clearError();
      
      expect(controller.hasError.value, false);
      expect(controller.error.value, '');
    });
  });
}
```

---

## 🎯 Best Practices

### **1. Always Use SafeCall/SafeApiCall**
```dart
// ✅ Good - proper error handling
void login() {
  safeCall(() async {
    await performLogin();
  }, errorMessage: 'ログインに失敗しました');
}

// ❌ Bad - no error handling
void login() async {
  await performLogin(); // Errors not handled
}
```

### **2. Setup Navigation in onReady**
```dart
// ✅ Good - proper navigation setup
@override
void onReady() {
  super.onReady();
  setupNavigation();
}

// ❌ Bad - missing navigation setup
@override
void onReady() {
  super.onReady();
  // Missing setupNavigation()
}
```

### **3. Use Request Navigation Pattern**
```dart
// ✅ Good - proper navigation pattern
void goToHome() {
  requestNavigation(Routes.HOME);
}

// ❌ Bad - direct navigation in controller
void goToHome() {
  Get.toNamed(Routes.HOME); // Violates GetX architecture
}
```

### **4. Clear Errors Appropriately**
```dart
// ✅ Good - clear errors when user fixes input
void onEmailChanged() {
  if (hasError.value) {
    clearError();
  }
}

// ❌ Bad - errors persist even after user fixes issues
```

### **5. Proper Resource Cleanup**
```dart
// ✅ Good - cleanup in onClose
@override
void onClose() {
  email.dispose();
  password.dispose();
  timer?.cancel();
  super.onClose(); // Important - calls clearNavigation()
}

// ❌ Bad - missing cleanup
@override
void onClose() {
  super.onClose();
  // Missing resource cleanup
}
```

---

## 📊 Migration Guide

### **Converting Existing Controllers**

```dart
// Before - standard GetxController
class OldController extends GetxController {
  final RxBool loading = false.obs;
  
  void someMethod() async {
    try {
      loading.value = true;
      await someAsyncOperation();
      Get.toNamed('/success');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }
}

// After - BaseController
class NewController extends BaseController {
  void someMethod() {
    safeCall(() async {
      await someAsyncOperation();
      requestNavigation('/success');
    }, errorMessage: 'Operation failed');
  }
  
  @override
  void onReady() {
    super.onReady();
    setupNavigation();
  }
}
```

---

## 📞 Support

For questions about BaseController implementation:
1. Check this usage guide first
2. Review the BaseController source code in `lib/controllers/base_controller.dart`
3. Test with the provided examples
4. Refer to Phase 3 Optimization Report for architectural details
5. Check ErrorManager and NavigationHelper documentation

---

**Remember**: BaseController provides a consistent foundation for all controllers in your app. By following these patterns, you ensure maintainable, testable, and scalable controller architecture throughout the KiokuNaviApp.