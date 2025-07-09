abstract class AuthApi {
  /// Login student with email and password
  Future<Map<String, dynamic>> loginStudent(String email, String password);

  /// Login parent with email and password
  Future<Map<String, dynamic>> loginParent(String email, String password);

  /// Logout current user
  Future<void> logout();

  /// Get current authenticated user data
  Future<Map<String, dynamic>> getCurrentUser();

  /// Refresh authentication token
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
}
