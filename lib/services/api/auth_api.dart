abstract class AuthApi {
  /// Login student with email and password
  /// Returns Laravel response: { "data": { "token": "...", "user": {...} } }
  Future<Map<String, dynamic>> loginStudent(String email, String password);

  /// Login parent with email and password
  /// Returns Laravel response: { "data": { "token": "...", "user": {...} } }
  Future<Map<String, dynamic>> loginParent(String email, String password);

  /// Register user with name, email, password, password confirmation and date of birth
  /// Returns Laravel response: { "data": { "token": "...", "user": {...} } }
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
    String dateOfBirth,
  );

  /// Logout current user (GET request)
  Future<void> logout();

  /// Get current authenticated user data
  Future<Map<String, dynamic>> getCurrentUser();

  /// Refresh access token (GET request)
  /// Returns new token response: { "data": { "token": "...", "token_type": "..." } }
  Future<Map<String, dynamic>> refreshToken();
}
