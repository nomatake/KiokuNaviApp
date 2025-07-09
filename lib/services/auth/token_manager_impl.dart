import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';

class TokenManagerImpl implements TokenManager {
  static const String _tokenKey = 'token';

  final FlutterSecureStorage _storage;

  // In-memory cache for performance
  String? _cachedToken;
  DateTime? _lastCacheUpdate;

  // Cache validity duration (5 minutes)
  static const Duration _cacheValidityDuration = Duration(minutes: 5);

  TokenManagerImpl({
    FlutterSecureStorage? storage,
  }) : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  @override
  Future<String?> getToken() async {
    // Check cache first
    if (_isCacheValid() && _cachedToken != null) {
      return _cachedToken;
    }

    // Read from secure storage
    final token = await _storage.read(key: _tokenKey);

    // Update cache
    _cachedToken = token;
    _lastCacheUpdate = DateTime.now();

    return token;
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);

    // Update cache
    _cachedToken = token;
    _lastCacheUpdate = DateTime.now();
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);

    // Clear cache
    _cachedToken = null;
    _lastCacheUpdate = null;
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  bool _isCacheValid() {
    if (_lastCacheUpdate == null) return false;
    return DateTime.now().difference(_lastCacheUpdate!) <
        _cacheValidityDuration;
  }
}
