abstract class TokenManager {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<bool> refreshTokens();
  Future<void> clearTokens();
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<bool> isAuthenticated();
}