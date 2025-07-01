import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kioku_navi/repositories/quiz_repository.dart';
import 'package:kioku_navi/models/quiz_session.dart';
import 'package:kioku_navi/models/question.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
import 'quiz_repository_test.mocks.dart';

void main() {
  group('QuizRepository', () {
    late QuizRepository quizRepository;
    late MockFlutterSecureStorage mockStorage;
    
    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      quizRepository = QuizRepository(storage: mockStorage);
    });
    
    group('Session Management', () {
      test('should save quiz session', () async {
        // Given: A quiz session
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
        
        final session = QuizSession(
          sessionId: 'session_123',
          questions: questions,
        );
        
        // When: Save session
        await quizRepository.saveSession(session);
        
        // Then: Session is saved to storage
        verify(mockStorage.write(
          key: 'quiz_session_session_123',
          value: argThat(contains('"session_id":"session_123"'), named: 'value'),
        )).called(1);
      });
      
      test('should retrieve saved session', () async {
        // Given: Session data in storage
        const sessionId = 'session_123';
        const sessionJson = '''
        {
          "session_id": "session_123",
          "questions": [{
            "question_id": "Q001",
            "concept_id": "C001",
            "subject": "Math",
            "grade": 5,
            "difficulty": 1,
            "format": "single",
            "stem": "What is 2 + 2?",
            "options": ["3", "4", "5", "6"],
            "answer": "4",
            "explanation": "2 + 2 = 4"
          }],
          "answers": {"Q001": "4"},
          "results": {"Q001": true},
          "start_time": "2024-01-01T10:00:00.000Z",
          "end_time": "2024-01-01T10:05:00.000Z"
        }
        ''';
        
        when(mockStorage.read(key: 'quiz_session_$sessionId'))
            .thenAnswer((_) async => sessionJson);
        
        // When: Get session
        final session = await quizRepository.getSession(sessionId);
        
        // Then: Session is retrieved correctly
        expect(session, isNotNull);
        expect(session!.sessionId, equals(sessionId));
        expect(session.questions.length, equals(1));
        expect(session.answers['Q001'], equals('4'));
        expect(session.results['Q001'], isTrue);
      });
      
      test('should return null for non-existent session', () async {
        // Given: No session in storage
        when(mockStorage.read(key: 'quiz_session_invalid'))
            .thenAnswer((_) async => null);
        
        // When: Get session
        final session = await quizRepository.getSession('invalid');
        
        // Then: Returns null
        expect(session, isNull);
      });
      
      test('should delete session', () async {
        // When: Delete session
        await quizRepository.deleteSession('session_123');
        
        // Then: Session is deleted from storage
        verify(mockStorage.delete(key: 'quiz_session_session_123')).called(1);
      });
    });
    
    group('Current Session', () {
      test('should save and retrieve current session', () async {
        // Given: A quiz session
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
        
        final session = QuizSession(
          sessionId: 'current_session',
          questions: questions,
        );
        
        // When: Save as current session
        await quizRepository.saveCurrentSession(session);
        
        // Then: Session is saved with special key
        verify(mockStorage.write(
          key: 'current_quiz_session',
          value: argThat(contains('"session_id":"current_session"'), named: 'value'),
        )).called(1);
      });
      
      test('should clear current session', () async {
        // When: Clear current session
        await quizRepository.clearCurrentSession();
        
        // Then: Current session is deleted
        verify(mockStorage.delete(key: 'current_quiz_session')).called(1);
      });
    });
    
    group('Session History', () {
      test('should save session to history', () async {
        // Given: Existing history
        when(mockStorage.read(key: 'quiz_history'))
            .thenAnswer((_) async => '["session_001", "session_002"]');
        
        // When: Add new session to history
        await quizRepository.addToHistory('session_003');
        
        // Then: History is updated
        verify(mockStorage.write(
          key: 'quiz_history',
          value: '["session_001","session_002","session_003"]',
        )).called(1);
      });
      
      test('should retrieve session history', () async {
        // Given: History in storage
        when(mockStorage.read(key: 'quiz_history'))
            .thenAnswer((_) async => '["session_001", "session_002", "session_003"]');
        
        // When: Get history
        final history = await quizRepository.getSessionHistory();
        
        // Then: History is returned
        expect(history.length, equals(3));
        expect(history, contains('session_001'));
        expect(history, contains('session_002'));
        expect(history, contains('session_003'));
      });
      
      test('should limit history size', () async {
        // Given: Full history (assuming max 50)
        final fullHistory = List.generate(50, (i) => '"session_${i.toString().padLeft(3, '0')}"');
        when(mockStorage.read(key: 'quiz_history'))
            .thenAnswer((_) async => '[${fullHistory.join(',')}]');
        
        // When: Add new session
        await quizRepository.addToHistory('session_051');
        
        // Then: Oldest session is removed
        final captured = verify(mockStorage.write(
          key: 'quiz_history',
          value: captureAnyNamed('value'),
        )).captured;
        final capturedValue = captured.single as String;
        
        expect(capturedValue.contains('session_000'), isFalse);
        expect(capturedValue.contains('session_051'), isTrue);
      });
    });
    
    group('Statistics', () {
      test('should calculate user statistics', () async {
        // Given: Multiple completed sessions
        final sessionIds = ['session_001', 'session_002', 'session_003'];
        when(mockStorage.read(key: 'quiz_history'))
            .thenAnswer((_) async => '["session_001", "session_002", "session_003"]');
        
        // Mock session data
        final sessions = {
          'session_001': '''
          {
            "session_id": "session_001",
            "questions": [{"question_id": "Q1", "concept_id": "C1", "subject": "Math", "grade": 5, "difficulty": 1, "format": "single", "stem": "Q", "answer": "A", "explanation": "E"}],
            "answers": {"Q1": "A"},
            "results": {"Q1": true},
            "start_time": "2024-01-01T10:00:00.000Z",
            "end_time": "2024-01-01T10:05:00.000Z",
            "total_questions": 1,
            "correct_answers": 1,
            "score": 100.0
          }
          ''',
          'session_002': '''
          {
            "session_id": "session_002",
            "questions": [{"question_id": "Q2", "concept_id": "C2", "subject": "Math", "grade": 5, "difficulty": 2, "format": "single", "stem": "Q", "answer": "B", "explanation": "E"}],
            "answers": {"Q2": "C"},
            "results": {"Q2": false},
            "start_time": "2024-01-02T10:00:00.000Z",
            "end_time": "2024-01-02T10:10:00.000Z",
            "total_questions": 1,
            "correct_answers": 0,
            "score": 0.0
          }
          ''',
          'session_003': '''
          {
            "session_id": "session_003",
            "questions": [
              {"question_id": "Q3", "concept_id": "C3", "subject": "Science", "grade": 5, "difficulty": 1, "format": "single", "stem": "Q", "answer": "A", "explanation": "E"},
              {"question_id": "Q4", "concept_id": "C4", "subject": "Science", "grade": 5, "difficulty": 2, "format": "single", "stem": "Q", "answer": "B", "explanation": "E"}
            ],
            "answers": {"Q3": "A", "Q4": "B"},
            "results": {"Q3": true, "Q4": true},
            "start_time": "2024-01-03T10:00:00.000Z",
            "end_time": "2024-01-03T10:15:00.000Z",
            "total_questions": 2,
            "correct_answers": 2,
            "score": 100.0
          }
          '''
        };
        
        sessions.forEach((id, data) {
          when(mockStorage.read(key: 'quiz_session_$id'))
              .thenAnswer((_) async => data);
        });
        
        // When: Calculate statistics
        final stats = await quizRepository.getUserStatistics();
        
        // Then: Statistics are calculated correctly
        expect(stats['total_sessions'], equals(3));
        expect(stats['total_questions'], equals(4));
        expect(stats['correct_answers'], equals(3));
        expect(stats['average_score'], closeTo(66.67, 0.01));
        expect(stats['subjects_attempted'], contains('Math'));
        expect(stats['subjects_attempted'], contains('Science'));
      });
    });
  });
}