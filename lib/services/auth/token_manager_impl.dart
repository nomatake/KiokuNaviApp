import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';

class TokenManagerImpl implements TokenManager {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage;
  final AuthApi _authApi;

  // In-memory cache for performance
  String? _cachedAccessToken;
  String? _cachedRefreshToken;
  DateTime? _lastCacheUpdate;

  // Cache validity duration (5 minutes)
  static const Duration _cacheValidityDuration = Duration(minutes: 5);

  TokenManagerImpl({
    required AuthApi authApi,
    FlutterSecureStorage? storage,
  })  : _authApi = authApi,
        _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  @override
  Future<String?> getAccessToken() async {
    // Check cache first
    if (_isCacheValid() && _cachedAccessToken != null) {
      return _cachedAccessToken;
    }

    // Read from secure storage
    final token = await _storage.read(key: _accessTokenKey);

    // Update cache
    _cachedAccessToken = token;
    _lastCacheUpdate = DateTime.now();

    return token;
  }

  @override
  Future<String?> getRefreshToken() async {
    // Check cache first
    if (_isCacheValid() && _cachedRefreshToken != null) {
      return _cachedRefreshToken;
    }

    // Read from secure storage
    final token = await _storage.read(key: _refreshTokenKey);

    // Update cache
    _cachedRefreshToken = token;
    _lastCacheUpdate = DateTime.now();

    return token;
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);

    // Update cache
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
    _lastCacheUpdate = DateTime.now();
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);

    // Update cache
    _cachedAccessToken = token;
    _lastCacheUpdate = DateTime.now();
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);

    // Update cache
    _cachedRefreshToken = token;
    _lastCacheUpdate = DateTime.now();
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);

    // Clear cache
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    _lastCacheUpdate = null;
  }

  @override
  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  @override
  Future<bool> refreshTokens() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // Make API call to refresh tokens using injected AuthApi
      final response = await _authApi.refreshToken(refreshToken);

      final newAccessToken = response['access_token'] as String;
      final newRefreshToken = response['refresh_token'] as String;

      await saveTokens(newAccessToken, newRefreshToken);
      return true;
    } catch (e) {
      // If refresh fails, clear all tokens
      await clearTokens();
      return false;
    }
  }

  bool _isCacheValid() {
    if (_lastCacheUpdate == null) return false;
    return DateTime.now().difference(_lastCacheUpdate!) <
        _cacheValidityDuration;
  }
}
