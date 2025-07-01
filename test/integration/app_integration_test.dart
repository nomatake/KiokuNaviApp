import 'package:flutter_test/flutter_test.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/api/auth_api_impl.dart';
import 'package:kioku_navi/services/api/quiz_api.dart';
import 'package:kioku_navi/services/api/quiz_api_impl.dart';
import 'package:kioku_navi/services/api/auth_interceptor.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/services/auth/token_manager_impl.dart';
import 'package:kioku_navi/services/auth/login_service.dart';
import 'package:kioku_navi/services/quiz/question_service.dart';
import 'package:kioku_navi/services/quiz/answer_validator_impl.dart';
import 'package:kioku_navi/repositories/user_repository.dart';
import 'package:kioku_navi/repositories/quiz_repository.dart';
import 'package:kioku_navi/controllers/auth_controller.dart';
import 'package:kioku_navi/controllers/quiz_controller.dart';
import 'package:kioku_navi/models/quiz_config.dart';
import 'package:kioku_navi/models/question.dart';
import 'package:kioku_navi/utils/constants.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
])
import 'app_integration_test.mocks.dart';

void main() {
  group('App Integration Tests', () {
    test('should integrate all services correctly', () async {
      // Create mock Dio
      final mockDio = MockDio();
      
      // Setup mock responses
      when(mockDio.interceptors).thenReturn(Interceptors());
      
      // Create real service instances with mock Dio
      final apiClient = BaseApiClient(dio: mockDio);
      final authApi = AuthApiImpl(apiClient: apiClient);
      final quizApi = QuizApiImpl(apiClient: apiClient);
      
      // Create repositories
      final userRepository = UserRepository();
      final quizRepository = QuizRepository();
      
      // Create services
      final tokenManager = TokenManagerImpl(authApi: authApi);
      final loginService = LoginService(
        authApi: authApi,
        tokenManager: tokenManager,
      );
      final questionService = QuestionService(quizApi: quizApi);
      final answerValidator = AnswerValidatorImpl();
      
      // Create controllers
      final authController = AuthController(
        loginService: loginService,
        userRepository: userRepository,
      );
      
      final quizController = QuizController(
        questionService: questionService,
        quizRepository: quizRepository,
        answerValidator: answerValidator,
      );
      
      // Add auth interceptor
      apiClient.dio.interceptors.add(
        AuthInterceptor(tokenManager: tokenManager),
      );
      
      // Verify all components are created successfully
      expect(apiClient, isNotNull);
      expect(authApi, isNotNull);
      expect(quizApi, isNotNull);
      expect(tokenManager, isNotNull);
      expect(loginService, isNotNull);
      expect(questionService, isNotNull);
      expect(answerValidator, isNotNull);
      expect(authController, isNotNull);
      expect(quizController, isNotNull);
      
      // Verify API client has interceptor
      expect(apiClient.dio.interceptors.length, greaterThan(0));
      
      // Test answer validator functionality
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
      
      final isCorrect = answerValidator.validate(
        question: question,
        userAnswer: '4',
      );
      
      expect(isCorrect, isTrue);
      
      final isIncorrect = answerValidator.validate(
        question: question,
        userAnswer: '3',
      );
      
      expect(isIncorrect, isFalse);
    });
    
    test('should handle different question formats correctly', () {
      final validator = AnswerValidatorImpl();
      
      // Test single choice
      final singleChoice = Question(
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
      
      expect(validator.validate(question: singleChoice, userAnswer: '4'), isTrue);
      expect(validator.validate(question: singleChoice, userAnswer: '3'), isFalse);
      
      // Test multiple choice
      final multiChoice = Question(
        questionId: 'Q002',
        conceptId: 'C002',
        subject: 'Math',
        grade: 5,
        difficulty: 2,
        format: QuestionFormat.multi,
        stem: 'Which are even?',
        options: ['1', '2', '3', '4'],
        answer: '2,4',
        explanation: 'Even numbers',
      );
      
      expect(validator.validate(question: multiChoice, userAnswer: ['2', '4']), isTrue);
      expect(validator.validate(question: multiChoice, userAnswer: ['2']), isFalse);
      
      // Test numeric input
      final numericInput = Question(
        questionId: 'Q003',
        conceptId: 'C003',
        subject: 'Math',
        grade: 5,
        difficulty: 1,
        format: QuestionFormat.numericInput,
        stem: 'What is 10 x 5?',
        answer: '50',
        explanation: '10 x 5 = 50',
      );
      
      expect(validator.validate(question: numericInput, userAnswer: '50'), isTrue);
      expect(validator.validate(question: numericInput, userAnswer: ' 50 '), isTrue);
      expect(validator.validate(question: numericInput, userAnswer: '51'), isFalse);
      
      // Test sequence
      final sequence = Question(
        questionId: 'Q004',
        conceptId: 'C004',
        subject: 'Math',
        grade: 5,
        difficulty: 2,
        format: QuestionFormat.sequence,
        stem: 'Order from smallest',
        options: ['5', '3', '8', '1'],
        answer: '1,3,5,8',
        explanation: 'Ascending order',
      );
      
      expect(validator.validate(question: sequence, userAnswer: ['1', '3', '5', '8']), isTrue);
      expect(validator.validate(question: sequence, userAnswer: ['1', '5', '3', '8']), isFalse);
      
      // Test matching
      final matching = Question(
        questionId: 'Q005',
        conceptId: 'C005',
        subject: 'Science',
        grade: 5,
        difficulty: 2,
        format: QuestionFormat.match,
        stem: 'Match animals to habitats',
        options: ['Fish:Water', 'Bird:Sky', 'Worm:Soil'],
        answer: 'Fish:Water,Bird:Sky,Worm:Soil',
        explanation: 'Natural habitats',
      );
      
      expect(validator.validate(
        question: matching,
        userAnswer: {'Fish': 'Water', 'Bird': 'Sky', 'Worm': 'Soil'}
      ), isTrue);
      
      expect(validator.validate(
        question: matching,
        userAnswer: {'Fish': 'Sky', 'Bird': 'Water', 'Worm': 'Soil'}
      ), isFalse);
    });
    
    test('should validate quiz configuration', () {
      // Valid config
      final validConfig = QuizConfig(
        curriculumId: 'Y5U-S-01',
        questionCount: 10,
        difficulties: [1, 2, 3],
        formats: [QuestionFormat.single, QuestionFormat.multi],
      );
      
      expect(validConfig.curriculumId, equals('Y5U-S-01'));
      expect(validConfig.questionCount, equals(10));
      expect(validConfig.difficulties.length, equals(3));
      expect(validConfig.formats.length, equals(2));
      
      // Test with different configs
      final conceptConfig = QuizConfig(
        conceptId: 'C001',
        questionCount: 5,
        difficulties: [1],
        formats: [QuestionFormat.single],
      );
      
      expect(conceptConfig.conceptId, equals('C001'));
      expect(conceptConfig.curriculumId, isNull);
    });
  });
}