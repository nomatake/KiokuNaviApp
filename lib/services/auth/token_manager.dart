abstract class TokenManager {
  /// Get the stored access token
  Future<String?> getToken();

  /// Save the access token
  Future<void> saveToken(String token);

  /// Clear the access token
  Future<void> clearToken();

  /// Check if user is authenticated (has valid access token)
  Future<bool> isAuthenticated();

  /// Synchronous method to get token for initial route determination
  String? getTokenSync();

  /// Synchronous method to check authentication for initial route determination
  bool isAuthenticatedSync();
}
