import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';

class TokenManagerImpl implements TokenManager {
  static const String _tokenKey = 'token';

  final GetStorage _storage;

  // In-memory cache for performance
  String? _cachedToken;
  DateTime? _lastCacheUpdate;

  // Cache validity duration (5 minutes)
  static const Duration _cacheValidityDuration = Duration(minutes: 5);

  TokenManagerImpl({
    GetStorage? storage,
  }) : _storage = storage ?? GetStorage();

  @override
  Future<String?> getToken() async {
    // Check cache first
    if (_isCacheValid() && _cachedToken != null) {
      return _cachedToken;
    }

    // Read from storage
    final token = _storage.read(_tokenKey);

    // Update cache
    _cachedToken = token;
    _lastCacheUpdate = DateTime.now();

    return token;
  }

  // Synchronous method to get token for initial route determination
  String? getTokenSync() {
    // Check cache first
    if (_isCacheValid() && _cachedToken != null) {
      return _cachedToken;
    }

    // Read from storage synchronously
    final token = _storage.read(_tokenKey);

    // Update cache
    _cachedToken = token;
    _lastCacheUpdate = DateTime.now();

    return token;
  }

  @override
  Future<void> saveToken(String token) async {
    _storage.write(_tokenKey, token);

    // Update cache
    _cachedToken = token;
    _lastCacheUpdate = DateTime.now();
  }

  @override
  Future<void> clearToken() async {
    _storage.remove(_tokenKey);

    // Clear cache
    _cachedToken = null;
    _lastCacheUpdate = null;
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Synchronous method to check authentication for initial route determination
  bool isAuthenticatedSync() {
    final token = getTokenSync();
    return token != null && token.isNotEmpty;
  }


  bool _isCacheValid() {
    if (_lastCacheUpdate == null) return false;
    return DateTime.now().difference(_lastCacheUpdate!) <
        _cacheValidityDuration;
  }
}
