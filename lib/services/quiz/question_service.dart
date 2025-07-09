import 'package:kioku_navi/services/api/quiz_api.dart';
import 'package:kioku_navi/models/question.dart';
import 'package:kioku_navi/models/quiz_config.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:get/get.dart';

class QuestionServiceException implements Exception {
  final String message;
  QuestionServiceException(this.message);
}

class QuestionService extends GetxService {
  final QuizApi quizApi;
  final Map<String, List<Question>> _curriculumCache = {};
  final Map<String, List<Question>> _conceptCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  
  static const Duration cacheExpiry = Duration(hours: 1);
  
  // Observable loading state
  final isLoading = false.obs;
  final currentQuestions = <Question>[].obs;
  
  QuestionService({required this.quizApi});
  
  Future<List<Question>> getQuestionsByCurriculum(String curriculumId) async {
    try {
      isLoading.value = true;
      
      // Check cache validity
      if (_isCacheValid('curriculum_$curriculumId')) {
        return _curriculumCache[curriculumId]!;
      }
      
      final questionsData = await quizApi.getQuestionsByCurriculum(curriculumId);
      final questions = _parseQuestions(questionsData);
      
      // Update cache
      _curriculumCache[curriculumId] = questions;
      _cacheTimestamps['curriculum_$curriculumId'] = DateTime.now();
      
      // Update observable list
      currentQuestions.value = questions;
      
      return questions;
    } on ApiException catch (e) {
      throw QuestionServiceException(
        'Failed to fetch questions for curriculum $curriculumId: ${e.message}'
      );
    } catch (e) {
      throw QuestionServiceException(
        'Unexpected error fetching questions: $e'
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<List<Question>> getQuestionsByConcept(String conceptId) async {
    try {
      isLoading.value = true;
      
      // Check cache validity
      if (_isCacheValid('concept_$conceptId')) {
        return _conceptCache[conceptId]!;
      }
      
      final questionsData = await quizApi.getQuestionsByConcept(conceptId);
      final questions = _parseQuestions(questionsData);
      
      // Update cache
      _conceptCache[conceptId] = questions;
      _cacheTimestamps['concept_$conceptId'] = DateTime.now();
      
      // Update observable list
      currentQuestions.value = questions;
      
      return questions;
    } on ApiException catch (e) {
      throw QuestionServiceException(
        'Failed to fetch questions for concept $conceptId: ${e.message}'
      );
    } catch (e) {
      throw QuestionServiceException(
        'Unexpected error fetching questions: $e'
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<List<Question>> generateQuiz(QuizConfig config) async {
    try {
      isLoading.value = true;
      
      final questionsData = await quizApi.generateQuiz(config.toJson());
      final questions = _parseQuestions(questionsData);
      
      // Update observable list
      currentQuestions.value = questions;
      
      return questions;
    } on ApiException catch (e) {
      throw QuestionServiceException(
        'Failed to generate quiz: ${e.message}'
      );
    } catch (e) {
      throw QuestionServiceException(
        'Unexpected error generating quiz: $e'
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<List<Question>> getQuestionsBatch(List<String> questionIds) async {
    try {
      isLoading.value = true;
      
      // Check if all questions are in cache
      final cachedQuestions = <Question>[];
      final missingIds = <String>[];
      
      for (final id in questionIds) {
        final cached = _findQuestionInCache(id);
        if (cached != null) {
          cachedQuestions.add(cached);
        } else {
          missingIds.add(id);
        }
      }
      
      // If all found in cache, return them
      if (missingIds.isEmpty) {
        return cachedQuestions;
      }
      
      // Otherwise, fetch all questions (API doesn't support batch by IDs)
      // This is a limitation that could be improved with a proper batch endpoint
      throw QuestionServiceException(
        'Batch fetching by IDs not supported. Use curriculum or concept fetch instead.'
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void clearCache() {
    _curriculumCache.clear();
    _conceptCache.clear();
    _cacheTimestamps.clear();
    currentQuestions.clear();
  }
  
  void clearExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];
    
    _cacheTimestamps.forEach((key, timestamp) {
      if (now.difference(timestamp) > cacheExpiry) {
        expiredKeys.add(key);
      }
    });
    
    for (final key in expiredKeys) {
      _cacheTimestamps.remove(key);
      if (key.startsWith('curriculum_')) {
        _curriculumCache.remove(key.substring(11));
      } else if (key.startsWith('concept_')) {
        _conceptCache.remove(key.substring(8));
      }
    }
  }
  
  List<Question> filterQuestions({
    List<int>? difficulties,
    List<QuestionFormat>? formats,
    String? subject,
  }) {
    var questions = currentQuestions.toList();
    
    if (difficulties != null && difficulties.isNotEmpty) {
      questions = questions
          .where((q) => difficulties.contains(q.difficulty))
          .toList();
    }
    
    if (formats != null && formats.isNotEmpty) {
      questions = questions
          .where((q) => formats.contains(q.format))
          .toList();
    }
    
    if (subject != null && subject.isNotEmpty) {
      questions = questions
          .where((q) => q.subject.toLowerCase() == subject.toLowerCase())
          .toList();
    }
    
    return questions;
  }
  
  // Private helper methods
  bool _isCacheValid(String key) {
    if (!_cacheTimestamps.containsKey(key)) return false;
    
    final timestamp = _cacheTimestamps[key]!;
    final age = DateTime.now().difference(timestamp);
    
    return age < cacheExpiry && 
           ((key.startsWith('curriculum_') && _curriculumCache.containsKey(key.substring(11))) ||
            (key.startsWith('concept_') && _conceptCache.containsKey(key.substring(8))));
  }
  
  List<Question> _parseQuestions(List<dynamic> questionsData) {
    try {
      return questionsData
          .map((data) => Question.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw QuestionServiceException('Failed to parse questions: $e');
    }
  }
  
  Question? _findQuestionInCache(String questionId) {
    // Search in curriculum cache
    for (final questions in _curriculumCache.values) {
      final found = questions.firstWhereOrNull((q) => q.questionId == questionId);
      if (found != null) return found;
    }
    
    // Search in concept cache
    for (final questions in _conceptCache.values) {
      final found = questions.firstWhereOrNull((q) => q.questionId == questionId);
      if (found != null) return found;
    }
    
    return null;
  }
  
  @override
  void onInit() {
    super.onInit();
    // Schedule periodic cache cleanup
    ever(currentQuestions, (_) => clearExpiredCache());
  }
}