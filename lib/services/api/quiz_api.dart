import 'package:kioku_navi/services/api/base_api_client.dart';

abstract class QuizApi {
  Future<List<dynamic>> getQuestionsByCurriculum(String curriculumId);
  Future<List<dynamic>> getQuestionsByConcept(String conceptId);
  Future<List<dynamic>> generateQuiz(Map<String, dynamic> config);
  Future<void> submitAnswer(Map<String, dynamic> answerData);
  Future<List<dynamic>> getQuizHistory();
}