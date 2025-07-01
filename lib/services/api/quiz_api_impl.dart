import 'package:kioku_navi/services/api/quiz_api.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';

class QuizApiImpl implements QuizApi {
  final BaseApiClient apiClient;
  
  QuizApiImpl({required this.apiClient});
  
  @override
  Future<List<dynamic>> getQuestionsByCurriculum(String curriculumId) async {
    final response = await apiClient.get<List<dynamic>>(
      '/api/questions/curriculum/$curriculumId',
    );
    
    return response;
  }
  
  @override
  Future<List<dynamic>> getQuestionsByConcept(String conceptId) async {
    final response = await apiClient.get<List<dynamic>>(
      '/api/questions/concept/$conceptId',
    );
    
    return response;
  }
  
  @override
  Future<List<dynamic>> generateQuiz(Map<String, dynamic> config) async {
    final response = await apiClient.post<List<dynamic>>(
      '/api/quiz/generate',
      data: config,
    );
    
    return response;
  }
  
  @override
  Future<void> submitAnswer(Map<String, dynamic> answerData) async {
    await apiClient.post('/api/quiz/answer', data: answerData);
  }
  
  @override
  Future<List<dynamic>> getQuizHistory() async {
    final response = await apiClient.get<List<dynamic>>(
      '/api/quiz/history',
    );
    
    return response;
  }
}