import '../models/models.dart';
import 'course_api.dart';

class CourseService {
  final CourseApi _courseApi;

  CourseService(this._courseApi);

  /// Gets all courses and converts them to Course models
  Future<List<Course>> getAllCourses() async {
    final response = await _courseApi.getCourses();
    final coursesData = response['data'] as List;

    return coursesData
        .map((courseJson) => Course.fromJson(courseJson))
        .toList();
  }

  /// Gets a specific course with chapters
  Future<Course?> getCourseWithChapters(int courseId) async {
    try {
      final response = await _courseApi.getCourse(courseId);
      final courseData = response['data'] as Map<String, dynamic>;

      return Course.fromJson(courseData);
    } catch (e) {
      // Handle error (e.g., course not found)
      return null;
    }
  }

  /// Gets chapters for a course
  Future<List<Chapter>> getCourseChapters(int courseId) async {
    final response = await _courseApi.getCourseChapters(courseId);
    final chaptersData = response['data'] as List;

    return chaptersData
        .map((chapterJson) => Chapter.fromJson(chapterJson))
        .toList();
  }

  /// Gets topics for a chapter
  Future<List<Topic>> getChapterTopics(int chapterId) async {
    final response = await _courseApi.getChapterTopics(chapterId);
    final topicsData = response['data'] as List;

    return topicsData.map((topicJson) => Topic.fromJson(topicJson)).toList();
  }

  /// Gets a topic with its questions
  Future<Topic?> getTopicWithQuestions(int topicId) async {
    try {
      final response = await _courseApi.getTopicWithQuestions(topicId);
      final topicData = response['data'] as Map<String, dynamic>;

      return Topic.fromJson(topicData);
    } catch (e) {
      // Handle error (e.g., topic not found)
      return null;
    }
  }

  /// Gets all questions for a topic
  Future<List<Question>> getTopicQuestions(int topicId) async {
    final topic = await getTopicWithQuestions(topicId);
    return topic?.contentBlocks ?? [];
  }

  /// Gets courses by grade level
  Future<List<Course>> getCoursesByGradeLevel(String gradeLevel) async {
    final courses = await getAllCourses();
    return courses.where((course) => course.gradeLevel == gradeLevel).toList();
  }

  /// Gets the full learning path: course -> chapters -> topics
  Future<List<Map<String, dynamic>>> getFullLearningPath(int courseId) async {
    final course = await getCourseWithChapters(courseId);
    if (course == null || course.chapters == null) return [];

    final learningPath = <Map<String, dynamic>>[];

    for (final chapter in course.chapters!) {
      final topics = await getChapterTopics(chapter.id);

      learningPath.add({
        'chapter': chapter,
        'topics': topics,
      });
    }

    return learningPath;
  }

  /// Gets the next topic in a chapter
  Future<Topic?> getNextTopicInChapter(
      int chapterId, int currentTopicOrder) async {
    final topics = await getChapterTopics(chapterId);
    topics.sort((a, b) => a.order.compareTo(b.order));

    final nextTopic =
        topics.where((topic) => topic.order > currentTopicOrder).firstOrNull;
    return nextTopic;
  }

  /// Gets the previous topic in a chapter
  Future<Topic?> getPreviousTopicInChapter(
      int chapterId, int currentTopicOrder) async {
    final topics = await getChapterTopics(chapterId);
    topics.sort((a, b) => b.order.compareTo(a.order)); // Reverse order

    final previousTopic =
        topics.where((topic) => topic.order < currentTopicOrder).firstOrNull;
    return previousTopic;
  }

  /// Checks if a topic is unlocked based on unlock level
  bool isTopicUnlocked(Topic topic, int userLevel) {
    return topic.unlockLevel == null || userLevel >= topic.unlockLevel!;
  }

  /// Gets unlocked topics for a chapter
  Future<List<Topic>> getUnlockedTopics(int chapterId, int userLevel) async {
    final topics = await getChapterTopics(chapterId);
    return topics.where((topic) => isTopicUnlocked(topic, userLevel)).toList();
  }
}

// Extension to add firstOrNull if not available
extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull {
    return isEmpty ? null : first;
  }
}
