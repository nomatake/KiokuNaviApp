import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/controllers/quiz_controller.dart';
import 'package:kioku_navi/services/quiz/question_service.dart';
import 'package:kioku_navi/repositories/quiz_repository.dart';
import 'package:kioku_navi/services/quiz/answer_validator.dart';
import 'package:kioku_navi/models/question.dart';
import 'package:kioku_navi/models/quiz_session.dart';
import 'package:kioku_navi/models/quiz_config.dart';

@GenerateNiceMocks([
  MockSpec<QuestionService>(),
  MockSpec<QuizRepository>(),
  MockSpec<AnswerValidator>(),
])
import 'quiz_controller_test.mocks.dart';

void main() {
  group('QuizController', () {
    late QuizController quizController;
    late MockQuestionService mockQuestionService;
    late MockQuizRepository mockQuizRepository;
    late MockAnswerValidator mockAnswerValidator;
    
    setUp(() {
      Get.testMode = true;
      mockQuestionService = MockQuestionService();
      mockQuizRepository = MockQuizRepository();
      mockAnswerValidator = MockAnswerValidator();
      
      quizController = QuizController(
        questionService: mockQuestionService,
        quizRepository: mockQuizRepository,
        answerValidator: mockAnswerValidator,
      );
    });
    
    tearDown(() {
      Get.reset();
    });
    
    group('Quiz Session Management', () {
      test('should start new quiz session', () async {
        // Given: Quiz config and questions
        final config = QuizConfig(
          curriculumId: 'Y5U-S-01',
          questionCount: 2,
          difficulties: [1, 2],
          formats: [QuestionFormat.single],
        );
        
        final questions = [
          Question(
            questionId: 'Q001',
            conceptId: 'C001',
            subject: 'Math',
            grade: 5,
            difficulty: 1,
            format: QuestionFormat.single,
            stem: 'What is 2 + 2?',
            options: ['3', '4', '5', '6'],
            answer: '4',
            explanation: '2 + 2 = 4',
          ),
          Question(
            questionId: 'Q002',
            conceptId: 'C002',
            subject: 'Math',
            grade: 5,
            difficulty: 2,
            format: QuestionFormat.single,
            stem: 'What is 5 x 6?',
            options: ['25', '30', '35', '40'],
            answer: '30',
            explanation: '5 x 6 = 30',
          ),
        ];
        
        when(mockQuestionService.generateQuiz(config))
            .thenAnswer((_) async => questions);
        
        // When: Start quiz
        final success = await quizController.startQuiz(config);
        
        // Then: Quiz session is created
        expect(success, isTrue);
        expect(quizController.hasActiveSession.value, isTrue);
        expect(quizController.currentQuestionIndex.value, equals(0));
        expect(quizController.totalQuestions.value, equals(2));
        expect(quizController.currentQuestion.value?.questionId, equals('Q001'));
        
        verify(mockQuizRepository.saveCurrentSession(any)).called(1);
      });
      
      test('should navigate between questions', () async {
        // Given: Active quiz session
        final questions = [
          Question(
            questionId: 'Q001',
            conceptId: 'C001',
            subject: 'Math',
            grade: 5,
            difficulty: 1,
            format: QuestionFormat.single,
            stem: 'Question 1',
            options: ['A', 'B', 'C', 'D'],
            answer: 'A',
            explanation: 'Explanation 1',
          ),
          Question(
            questionId: 'Q002',
            conceptId: 'C002',
            subject: 'Math',
            grade: 5,
            difficulty: 1,
            format: QuestionFormat.single,
            stem: 'Question 2',
            options: ['A', 'B', 'C', 'D'],
            answer: 'B',
            explanation: 'Explanation 2',
          ),
        ];
        
        final config = QuizConfig(
          curriculumId: 'Y5U-S-01',
          questionCount: 2,
          difficulties: [1],
          formats: [QuestionFormat.single],
        );
        
        when(mockQuestionService.generateQuiz(config))
            .thenAnswer((_) async => questions);
        
        await quizController.startQuiz(config);
        
        // When: Navigate to next question
        quizController.nextQuestion();
        
        // Then: Current question is updated
        expect(quizController.currentQuestionIndex.value, equals(1));
        expect(quizController.currentQuestion.value?.questionId, equals('Q002'));
        expect(quizController.canGoNext, isFalse);
        expect(quizController.canGoPrevious, isTrue);
        
        // When: Navigate to previous question
        quizController.previousQuestion();
        
        // Then: Back to first question
        expect(quizController.currentQuestionIndex.value, equals(0));
        expect(quizController.currentQuestion.value?.questionId, equals('Q001'));
      });
    });
    
    group('Answer Submission', () {
      test('should submit and validate answer', () async {
        // Given: Active quiz with a question
        final question = Question(
          questionId: 'Q001',
          conceptId: 'C001',
          subject: 'Math',
          grade: 5,
          difficulty: 1,
          format: QuestionFormat.single,
          stem: 'What is 2 + 2?',
          options: ['3', '4', '5', '6'],
          answer: '4',
          explanation: '2 + 2 = 4',
        );
        
        final config = QuizConfig(
          curriculumId: 'Y5U-S-01',
          questionCount: 1,
          difficulties: [1],
          formats: [QuestionFormat.single],
        );
        
        when(mockQuestionService.generateQuiz(config))
            .thenAnswer((_) async => [question]);
        
        when(mockAnswerValidator.validate(
          question: question,
          userAnswer: '4',
        )).thenReturn(true);
        
        await quizController.startQuiz(config);
        
        // When: Submit answer
        await quizController.submitAnswer('4');
        
        // Then: Answer is recorded
        expect(quizController.isCurrentQuestionAnswered, isTrue);
        expect(quizController.userAnswers['Q001'], equals('4'));
        
        verify(mockAnswerValidator.validate(
          question: question,
          userAnswer: '4',
        )).called(1);
        
        verify(mockQuizRepository.saveCurrentSession(any)).called(greaterThan(1));
      });
      
      test('should handle incorrect answer', () async {
        // Given: Active quiz with a question
        final question = Question(
          questionId: 'Q001',
          conceptId: 'C001',
          subject: 'Math',
          grade: 5,
          difficulty: 1,
          format: QuestionFormat.single,
          stem: 'What is 2 + 2?',
          options: ['3', '4', '5', '6'],
          answer: '4',
          explanation: '2 + 2 = 4',
        );
        
        final config = QuizConfig(
          curriculumId: 'Y5U-S-01',
          questionCount: 1,
          difficulties: [1],
          formats: [QuestionFormat.single],
        );
        
        when(mockQuestionService.generateQuiz(config))
            .thenAnswer((_) async => [question]);
        
        when(mockAnswerValidator.validate(
          question: question,
          userAnswer: '3',
        )).thenReturn(false);
        
        await quizController.startQuiz(config);
        
        // When: Submit incorrect answer
        await quizController.submitAnswer('3');
        
        // Then: Answer is marked as incorrect
        expect(quizController.isCurrentQuestionAnswered, isTrue);
        expect(quizController.userAnswers['Q001'], equals('3'));
      });
    });
    
    group('Quiz Completion', () {
      test('should complete quiz session', () async {
        // Given: Active quiz session with all questions answered
        final questions = [
          Question(
            questionId: 'Q001',
            conceptId: 'C001',
            subject: 'Math',
            grade: 5,
            difficulty: 1,
            format: QuestionFormat.single,
            stem: 'Question 1',
            options: ['A', 'B', 'C', 'D'],
            answer: 'A',
            explanation: 'Explanation 1',
          ),
        ];
        
        final config = QuizConfig(
          curriculumId: 'Y5U-S-01',
          questionCount: 1,
          difficulties: [1],
          formats: [QuestionFormat.single],
        );
        
        when(mockQuestionService.generateQuiz(config))
            .thenAnswer((_) async => questions);
        
        when(mockAnswerValidator.validate(
          question: questions[0],
          userAnswer: 'A',
        )).thenReturn(true);
        
        await quizController.startQuiz(config);
        await quizController.submitAnswer('A');
        
        // When: Complete quiz
        await quizController.completeQuiz();
        
        // Then: Quiz is completed and saved
        expect(quizController.hasActiveSession.value, isFalse);
        expect(quizController.lastScore.value, equals(100.0));
        
        verify(mockQuizRepository.saveSession(any)).called(1);
        verify(mockQuizRepository.addToHistory(any)).called(1);
        verify(mockQuizRepository.clearCurrentSession()).called(1);
      });
    });
    
    group('Progress Tracking', () {
      test('should track quiz progress', () async {
        // Given: Quiz with multiple questions
        final questions = List.generate(5, (i) => Question(
          questionId: 'Q00${i + 1}',
          conceptId: 'C00${i + 1}',
          subject: 'Math',
          grade: 5,
          difficulty: 1,
          format: QuestionFormat.single,
          stem: 'Question ${i + 1}',
          options: ['A', 'B', 'C', 'D'],
          answer: 'A',
          explanation: 'Explanation ${i + 1}',
        ));
        
        final config = QuizConfig(
          curriculumId: 'Y5U-S-01',
          questionCount: 5,
          difficulties: [1],
          formats: [QuestionFormat.single],
        );
        
        when(mockQuestionService.generateQuiz(config))
            .thenAnswer((_) async => questions);
        
        await quizController.startQuiz(config);
        
        // Initial progress
        expect(quizController.progress, equals(0.0));
        expect(quizController.answeredCount, equals(0));
        
        // Answer some questions
        when(mockAnswerValidator.validate(
          question: anyNamed('question'),
          userAnswer: anyNamed('userAnswer'),
        )).thenReturn(true);
        
        await quizController.submitAnswer('A');
        expect(quizController.progress, closeTo(0.2, 0.01));
        expect(quizController.answeredCount, equals(1));
        
        quizController.nextQuestion();
        await quizController.submitAnswer('B');
        expect(quizController.progress, closeTo(0.4, 0.01));
        expect(quizController.answeredCount, equals(2));
      });
    });
    
    group('State Restoration', () {
      test('should restore quiz session', () async {
        // Given: Saved quiz session
        final questions = [
          Question(
            questionId: 'Q001',
            conceptId: 'C001',
            subject: 'Math',
            grade: 5,
            difficulty: 1,
            format: QuestionFormat.single,
            stem: 'What is 2 + 2?',
            options: ['3', '4', '5', '6'],
            answer: '4',
            explanation: '2 + 2 = 4',
          ),
        ];
        
        final savedSession = QuizSession(
          sessionId: 'saved_session',
          questions: questions,
        );
        savedSession.recordAnswer('Q001', '4', true);
        
        when(mockQuizRepository.getCurrentSession())
            .thenAnswer((_) async => savedSession);
        
        // When: Initialize controller
        quizController.onInit();
        await Future.delayed(Duration(milliseconds: 100));
        
        // Then: Session is restored
        expect(quizController.hasActiveSession.value, isTrue);
        expect(quizController.userAnswers['Q001'], equals('4'));
        expect(quizController.isCurrentQuestionAnswered, isTrue);
      });
    });
  });
}