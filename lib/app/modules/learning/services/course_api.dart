abstract class CourseApi {
  /// Get all courses
  /// Returns Laravel response: { "data": [...] }
  Future<Map<String, dynamic>> getCourses();

  /// Get course with chapters by ID
  /// Returns Laravel response: { "data": { "id": ..., "chapters": [...] } }
  Future<Map<String, dynamic>> getCourse(int courseId);

  /// Get chapters for a specific course
  /// Returns Laravel response: { "data": [...] }
  Future<Map<String, dynamic>> getCourseChapters(int courseId);

  /// Get topics for a specific chapter
  /// Returns Laravel response: { "data": [...] }
  Future<Map<String, dynamic>> getChapterTopics(int chapterId);

  /// Get topic with questions (content blocks) by ID
  /// Returns Laravel response: { "data": { "id": ..., "content_blocks": [...] } }
  Future<Map<String, dynamic>> getTopicWithQuestions(int topicId);
}
