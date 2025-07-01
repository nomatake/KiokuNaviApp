import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kioku_navi/services/quiz/question_service.dart';
import 'package:kioku_navi/services/api/quiz_api.dart';
import 'package:kioku_navi/models/question.dart';
import 'package:kioku_navi/models/quiz_config.dart';

@GenerateNiceMocks([MockSpec<QuizApi>()])
import 'question_service_test.mocks.dart';

void main() {
  group('QuestionService', () {
    late QuestionService questionService;
    late MockQuizApi mockQuizApi;
    
    setUp(() {
      mockQuizApi = MockQuizApi();
      questionService = QuestionService(quizApi: mockQuizApi);
    });
    
    group('Fetch Questions', () {
      test('should fetch questions by curriculum', () async {
        // Given: Curriculum ID and API response
        const curriculumId = 'Y5U-S-01';
        final questionsData = [
          {
            'question_id': 'Q001',
            'concept_id': 'C_SOC_5U_01',
            'curriculum_id': curriculumId,
            'subject': 'Social',
            'grade': 5,
            'difficulty': 1,
            'format': 'single',
            'stem': 'Which of the following is the capital of Japan?',
            'options': ['Tokyo', 'Osaka', 'Kyoto', 'Nagoya'],
            'answer': 'Tokyo',
            'image_ref': null,
            'explanation': 'Tokyo has been the capital of Japan since 1868.',
          },
          {
            'question_id': 'Q002',
            'concept_id': 'C_SOC_5U_01',
            'curriculum_id': curriculumId,
            'subject': 'Social',
            'grade': 5,
            'difficulty': 2,
            'format': 'multi',
            'stem': 'Select all major islands of Japan:',
            'options': ['Honshu', 'Kyushu', 'Shikoku', 'Hokkaido', 'Taiwan'],
            'answer': 'Honshu,Kyushu,Shikoku,Hokkaido',
            'image_ref': null,
            'explanation': 'Japan consists of four main islands.',
          },
        ];
        
        when(mockQuizApi.getQuestionsByCurriculum(curriculumId))
            .thenAnswer((_) async => questionsData);
        
        // When: Fetch questions
        final questions = await questionService.getQuestionsByCurriculum(curriculumId);
        
        // Then: Questions are returned correctly
        expect(questions.length, equals(2));
        expect(questions[0].questionId, equals('Q001'));
        expect(questions[0].format, equals(QuestionFormat.single));
        expect(questions[1].format, equals(QuestionFormat.multi));
        
        verify(mockQuizApi.getQuestionsByCurriculum(curriculumId)).called(1);
      });
      
      test('should fetch questions by concept', () async {
        // Given: Concept ID and API response
        const conceptId = 'C_SOC_5U_01';
        final questionsData = [
          {
            'question_id': 'Q003',
            'concept_id': conceptId,
            'curriculum_id': 'Y5U-S-01',
            'subject': 'Social',
            'grade': 5,
            'difficulty': 1,
            'format': 'single',
            'stem': 'What is the highest mountain in Japan?',
            'options': ['Mt. Fuji', 'Mt. Tateyama', 'Mt. Aso', 'Mt. Hakusan'],
            'answer': 'Mt. Fuji',
            'image_ref': null,
            'explanation': 'Mt. Fuji is 3,776 meters high.',
          },
        ];
        
        when(mockQuizApi.getQuestionsByConcept(conceptId))
            .thenAnswer((_) async => questionsData);
        
        // When: Fetch questions
        final questions = await questionService.getQuestionsByConcept(conceptId);
        
        // Then: Questions are returned correctly
        expect(questions.length, equals(1));
        expect(questions[0].conceptId, equals(conceptId));
        
        verify(mockQuizApi.getQuestionsByConcept(conceptId)).called(1);
      });
      
      test('should handle empty response', () async {
        // Given: Empty API response
        const curriculumId = 'Y5U-S-01';
        
        when(mockQuizApi.getQuestionsByCurriculum(curriculumId))
            .thenAnswer((_) async => []);
        
        // When: Fetch questions
        final questions = await questionService.getQuestionsByCurriculum(curriculumId);
        
        // Then: Empty list is returned
        expect(questions, isEmpty);
      });
    });
    
    group('Generate Quiz', () {
      test('should generate quiz with config', () async {
        // Given: Quiz configuration
        final config = QuizConfig(
          curriculumId: 'Y5U-S-01',
          questionCount: 10,
          difficulties: [1, 2, 3],
          formats: [QuestionFormat.single, QuestionFormat.multi],
        );
        
        final questionsData = [
          {
            'question_id': 'Q001',
            'concept_id': 'C_SOC_5U_01',
            'curriculum_id': 'Y5U-S-01',
            'subject': 'Social',
            'grade': 5,
            'difficulty': 1,
            'format': 'single',
            'stem': 'Question 1',
            'options': ['A', 'B', 'C', 'D'],
            'answer': 'A',
            'image_ref': null,
            'explanation': 'Explanation 1',
          },
        ];
        
        when(mockQuizApi.generateQuiz(config.toJson()))
            .thenAnswer((_) async => questionsData);
        
        // When: Generate quiz
        final questions = await questionService.generateQuiz(config);
        
        // Then: Quiz is generated
        expect(questions.length, equals(1));
        expect(questions[0].questionId, equals('Q001'));
        
        verify(mockQuizApi.generateQuiz(config.toJson())).called(1);
      });
    });
    
    group('Caching', () {
      test('should cache questions by curriculum', () async {
        // Given: Curriculum ID and API response
        const curriculumId = 'Y5U-S-01';
        final questionsData = [
          {
            'question_id': 'Q001',
            'concept_id': 'C_SOC_5U_01',
            'curriculum_id': curriculumId,
            'subject': 'Social',
            'grade': 5,
            'difficulty': 1,
            'format': 'single',
            'stem': 'Cached question',
            'options': ['A', 'B', 'C', 'D'],
            'answer': 'A',
            'image_ref': null,
            'explanation': 'Cached explanation',
          },
        ];
        
        when(mockQuizApi.getQuestionsByCurriculum(curriculumId))
            .thenAnswer((_) async => questionsData);
        
        // When: Fetch questions twice
        final questions1 = await questionService.getQuestionsByCurriculum(curriculumId);
        final questions2 = await questionService.getQuestionsByCurriculum(curriculumId);
        
        // Then: API is called only once (cached)
        expect(questions1, equals(questions2));
        verify(mockQuizApi.getQuestionsByCurriculum(curriculumId)).called(1);
      });
      
      test('should clear cache', () async {
        // Given: Cached questions
        const curriculumId = 'Y5U-S-01';
        final questionsData = [
          {
            'question_id': 'Q001',
            'concept_id': 'C_SOC_5U_01',
            'curriculum_id': curriculumId,
            'subject': 'Social',
            'grade': 5,
            'difficulty': 1,
            'format': 'single',
            'stem': 'Question',
            'options': ['A', 'B', 'C', 'D'],
            'answer': 'A',
            'image_ref': null,
            'explanation': 'Explanation',
          },
        ];
        
        when(mockQuizApi.getQuestionsByCurriculum(curriculumId))
            .thenAnswer((_) async => questionsData);
        
        // When: Fetch, clear cache, and fetch again
        await questionService.getQuestionsByCurriculum(curriculumId);
        questionService.clearCache();
        await questionService.getQuestionsByCurriculum(curriculumId);
        
        // Then: API is called twice
        verify(mockQuizApi.getQuestionsByCurriculum(curriculumId)).called(2);
      });
    });
  });
}