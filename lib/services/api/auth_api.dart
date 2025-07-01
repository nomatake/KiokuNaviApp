abstract class AuthApi {
  Future<Map<String, dynamic>> loginStudent(String studentId, String password);
  Future<Map<String, dynamic>> loginParent(String email, String password);
  Future<void> logout();
  Future<Map<String, dynamic>> getCurrentUser();
}