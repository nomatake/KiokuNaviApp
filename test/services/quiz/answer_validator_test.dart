import 'package:flutter_test/flutter_test.dart';
import 'package:kioku_navi/services/quiz/answer_validator.dart';
import 'package:kioku_navi/services/quiz/answer_validator_impl.dart';
import 'package:kioku_navi/models/question.dart';

void main() {
  group('AnswerValidatorImpl', () {
    late AnswerValidator validator;
    
    setUp(() {
      validator = AnswerValidatorImpl();
    });
    
    group('Single Choice Questions', () {
      test('should validate correct single choice answer', () {
        // Given: Single choice question
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
        
        // When: Validate correct answer
        final isCorrect = validator.validate(
          question: question,
          userAnswer: '4',
        );
        
        // Then: Should be correct
        expect(isCorrect, isTrue);
      });
      
      test('should invalidate incorrect single choice answer', () {
        // Given: Single choice question
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
        
        // When: Validate incorrect answer
        final isCorrect = validator.validate(
          question: question,
          userAnswer: '3',
        );
        
        // Then: Should be incorrect
        expect(isCorrect, isFalse);
      });
    });
    
    group('Multiple Choice Questions', () {
      test('should validate correct multiple choice answers', () {
        // Given: Multiple choice question with multiple correct answers
        final question = Question(
          questionId: 'Q002',
          conceptId: 'C002',
          subject: 'Math',
          grade: 5,
          difficulty: 2,
          format: QuestionFormat.multi,
          stem: 'Which are even numbers?',
          options: ['1', '2', '3', '4'],
          answer: '2,4',
          explanation: '2 and 4 are even numbers',
        );
        
        // When: Validate correct answers
        final isCorrect = validator.validate(
          question: question,
          userAnswer: ['2', '4'],
        );
        
        // Then: Should be correct
        expect(isCorrect, isTrue);
      });
      
      test('should invalidate partial multiple choice answers', () {
        // Given: Multiple choice question
        final question = Question(
          questionId: 'Q002',
          conceptId: 'C002',
          subject: 'Math',
          grade: 5,
          difficulty: 2,
          format: QuestionFormat.multi,
          stem: 'Which are even numbers?',
          options: ['1', '2', '3', '4'],
          answer: '2,4',
          explanation: '2 and 4 are even numbers',
        );
        
        // When: Validate partial answer
        final isCorrect = validator.validate(
          question: question,
          userAnswer: ['2'],
        );
        
        // Then: Should be incorrect
        expect(isCorrect, isFalse);
      });
    });
    
    group('Numeric Input Questions', () {
      test('should validate correct numeric answer', () {
        // Given: Numeric input question
        final question = Question(
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
        
        // When: Validate correct answer
        final isCorrect = validator.validate(
          question: question,
          userAnswer: '50',
        );
        
        // Then: Should be correct
        expect(isCorrect, isTrue);
      });
      
      test('should validate numeric answer with different formats', () {
        // Given: Numeric input question
        final question = Question(
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
        
        // When: Validate answer with spaces
        final isCorrect = validator.validate(
          question: question,
          userAnswer: ' 50 ',
        );
        
        // Then: Should be correct (trimmed)
        expect(isCorrect, isTrue);
      });
    });
    
    group('Sequence Questions', () {
      test('should validate correct sequence', () {
        // Given: Sequence question
        final question = Question(
          questionId: 'Q004',
          conceptId: 'C004',
          subject: 'Math',
          grade: 5,
          difficulty: 2,
          format: QuestionFormat.sequence,
          stem: 'Order from smallest to largest',
          options: ['5', '3', '8', '1'],
          answer: '1,3,5,8',
          explanation: 'The correct order is 1, 3, 5, 8',
        );
        
        // When: Validate correct sequence
        final isCorrect = validator.validate(
          question: question,
          userAnswer: ['1', '3', '5', '8'],
        );
        
        // Then: Should be correct
        expect(isCorrect, isTrue);
      });
      
      test('should invalidate incorrect sequence', () {
        // Given: Sequence question
        final question = Question(
          questionId: 'Q004',
          conceptId: 'C004',
          subject: 'Math',
          grade: 5,
          difficulty: 2,
          format: QuestionFormat.sequence,
          stem: 'Order from smallest to largest',
          options: ['5', '3', '8', '1'],
          answer: '1,3,5,8',
          explanation: 'The correct order is 1, 3, 5, 8',
        );
        
        // When: Validate incorrect sequence
        final isCorrect = validator.validate(
          question: question,
          userAnswer: ['1', '5', '3', '8'],
        );
        
        // Then: Should be incorrect
        expect(isCorrect, isFalse);
      });
    });
    
    group('Matching Questions', () {
      test('should validate correct matches', () {
        // Given: Matching question
        final question = Question(
          questionId: 'Q005',
          conceptId: 'C005',
          subject: 'Science',
          grade: 5,
          difficulty: 2,
          format: QuestionFormat.match,
          stem: 'Match animals to their habitats',
          options: ['Fish:Water', 'Bird:Sky', 'Worm:Soil'],
          answer: 'Fish:Water,Bird:Sky,Worm:Soil',
          explanation: 'Animals live in their natural habitats',
        );
        
        // When: Validate correct matches
        final isCorrect = validator.validate(
          question: question,
          userAnswer: {'Fish': 'Water', 'Bird': 'Sky', 'Worm': 'Soil'},
        );
        
        // Then: Should be correct
        expect(isCorrect, isTrue);
      });
      
      test('should invalidate incorrect matches', () {
        // Given: Matching question
        final question = Question(
          questionId: 'Q005',
          conceptId: 'C005',
          subject: 'Science',
          grade: 5,
          difficulty: 2,
          format: QuestionFormat.match,
          stem: 'Match animals to their habitats',
          options: ['Fish:Water', 'Bird:Sky', 'Worm:Soil'],
          answer: 'Fish:Water,Bird:Sky,Worm:Soil',
          explanation: 'Animals live in their natural habitats',
        );
        
        // When: Validate incorrect matches
        final isCorrect = validator.validate(
          question: question,
          userAnswer: {'Fish': 'Sky', 'Bird': 'Water', 'Worm': 'Soil'},
        );
        
        // Then: Should be incorrect
        expect(isCorrect, isFalse);
      });
    });
  });
}