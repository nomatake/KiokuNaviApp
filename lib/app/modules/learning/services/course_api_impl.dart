import 'package:kioku_navi/services/api/base_api_client.dart';

import 'course_api.dart';

class CourseApiImpl implements CourseApi {
  final BaseApiClient apiClient;

  CourseApiImpl({
    required this.apiClient,
  });

  @override
  Future<Map<String, dynamic>> getCourses() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'courses',
    );

    return response;
  }

  @override
  Future<Map<String, dynamic>> getCourse(int courseId) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'courses/$courseId',
    );

    return response;
  }

  @override
  Future<Map<String, dynamic>> getCourseChapters(int courseId) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'courses/$courseId/chapters',
    );

    return response;
  }

  @override
  Future<Map<String, dynamic>> getChapterTopics(int chapterId) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'chapters/$chapterId/topics',
    );

    return response;
  }

  @override
  Future<Map<String, dynamic>> getTopicWithQuestions(int topicId) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'topics/$topicId',
    );

    return response;
  }
}
