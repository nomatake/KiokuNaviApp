import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:kioku_navi/services/api/auth_api.dart';

class TokenManagerImpl implements TokenManager {
  final AuthApi authApi;
  final FlutterSecureStorage _storage;
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  String? _cachedAccessToken;
  String? _cachedRefreshToken;
  
  TokenManagerImpl({
    required this.authApi,
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();
  
  @override
  Future<String?> getAccessToken() async {
    _cachedAccessToken ??= await _storage.read(key: _accessTokenKey);
    return _cachedAccessToken;
  }
  
  @override
  Future<String?> getRefreshToken() async {
    _cachedRefreshToken ??= await _storage.read(key: _refreshTokenKey);
    return _cachedRefreshToken;
  }
  
  @override
  Future<bool> refreshTokens() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;
    
    try {
      // Call refresh API endpoint
      final response = await authApi.loginParent('', ''); // This should be a proper refresh endpoint
      
      // Extract tokens from response
      final accessToken = response['access_token'] as String?;
      final newRefreshToken = response['refresh_token'] as String?;
      
      if (accessToken != null) {
        await saveAccessToken(accessToken);
        if (newRefreshToken != null) {
          await saveRefreshToken(newRefreshToken);
        }
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<void> clearTokens() async {
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
    
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
  
  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
    
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }
  
  @override
  Future<void> saveAccessToken(String token) async {
    _cachedAccessToken = token;
    await _storage.write(key: _accessTokenKey, value: token);
  }
  
  @override
  Future<void> saveRefreshToken(String token) async {
    _cachedRefreshToken = token;
    await _storage.write(key: _refreshTokenKey, value: token);
  }
  
  @override
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}