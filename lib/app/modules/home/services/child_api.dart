abstract class ChildApi {
  /// Get child home data with courses, chapters, and topics
  /// Returns Laravel response: { "data": [...] }
  Future<Map<String, dynamic>> getChildHome();
}