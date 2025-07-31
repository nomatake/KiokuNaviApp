import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';
import 'package:dio/dio.dart';
import '../../models/auth_models.dart';
import '../../models/child_model.dart';
import '../../models/family_model.dart';
import '../../models/user_model.dart';
import '../../utils/device_utils.dart';

class AuthApiImpl implements AuthApi {
  final BaseApiClient apiClient;
  final TokenManager tokenManager;
  final GetStorage _storage;

  static const String _childSessionTokenKey = 'child_session_token';
  static const String _currentChildKey = 'current_child';
  static const String _provisionalTokenKey = 'provisional_token';
  static const String _tempTokenKey = 'temp_token';
  static const String _userDataKey = 'user_data';
  static const String _familyDataKey = 'family_data';
  static const String _lastLoggedInChildIdKey = 'last_logged_in_child_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _isStudentKey = 'is_student';

  static const String _familyAuthPrefix = 'family/auth';
  static const String _familyChildPrefix = 'family/child';
  static const String _familyPrefix = 'family';

  AuthApiImpl({
    required this.apiClient,
    required this.tokenManager,
    GetStorage? storage,
  }) : _storage = storage ?? GetStorage();

  Options _createChildTokenOptions({Map<String, String>? headers}) {
    return Options(
      extra: {'forceChildToken': true},
      headers: headers,
    );
  }

  Options _createDeviceHeaderOptions(DeviceInfo deviceInfo) {
    return Options(headers: deviceInfo.toHeaders());
  }

  Options _createChildTokenWithDeviceOptions(DeviceInfo deviceInfo) {
    return Options(
      extra: {'forceChildToken': true},
      headers: deviceInfo.toHeaders(),
    );
  }

  Future<Map<String, String>?> _getDeviceHeadersSafely() async {
    try {
      final deviceInfo = await DeviceUtils.getDeviceInfo();
      return deviceInfo.toHeaders();
    } catch (e) {
      return null;
    }
  }

  Map<String, String> _createBearerTokenHeader(String token) {
    return {'Authorization': 'Bearer $token'};
  }

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('AuthAPI: $message');
    }
  }

  Future<AuthResult> _performAuthApiCall(
    String endpoint, {
    dynamic data,
    Options? options,
  }) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      endpoint,
      data: data,
      options: options,
    );
    return AuthResult.fromJson(response);
  }

  String _formatDateForApi(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  @override
  Future<Map<String, dynamic>> preRegisterParent(String email) async {
    return await apiClient.post<Map<String, dynamic>>(
      '$_familyAuthPrefix/pre-register',
      data: {'email': email},
    );
  }

  @override
  Future<AuthResult> verifyEmail(String email, String otp) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '$_familyAuthPrefix/verify-email',
      data: {'email': email, 'otp': otp},
    );

    final result = AuthResult.fromJson(response);

    if (result.provisionalToken != null) {
      await _storage.write(_tempTokenKey, result.provisionalToken);
    }

    return result;
  }

  @override
  Future<AuthResult> completeParentProfile(
      ParentProfileCompletion profileData) async {
    final result = await _performAuthApiCall(
      '$_familyAuthPrefix/complete-profile',
      data: profileData.toJson(),
    );
    await _saveAuthenticationData(result);
    return result;
  }

  @override
  Future<AuthResult> loginParent(String email, String password) async {
    final result = await _performAuthApiCall(
      '$_familyAuthPrefix/login',
      data: {'email': email, 'password': password},
    );
    await _saveAuthenticationData(result);
    return result;
  }

  @override
  Future<AuthResult> registerParent(ParentRegistration registrationData) async {
    final result = await _performAuthApiCall(
      '$_familyAuthPrefix/register',
      data: registrationData.toJson(),
    );
    await _saveAuthenticationData(result);
    return result;
  }

  @override
  Future<Map<String, dynamic>> associateDevice(
      String deviceFingerprint, String platform) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'family/auth/associate-device',
      options: Options(headers: {
        'X-Device-Fingerprint': deviceFingerprint,
        'X-Device-Platform': platform,
      }),
    );

    return response['data'] as Map<String, dynamic>;
  }

  @override
  Future<AuthResult> joinWithCode(ChildJoinRequest request) async {
    final result = await _performAuthApiCall(
      '$_familyChildPrefix/join',
      data: request.toJson(),
      options: _createDeviceHeaderOptions(request.deviceInfo),
    );

    if (result.provisionalToken != null) {
      await _storage.write(_provisionalTokenKey, result.provisionalToken);
    }

    return result;
  }

  @override
  Future<AuthResult> setChildPin(ChildPinSetup pinData) async {
    final result = await _performAuthApiCall(
      '$_familyChildPrefix/set-pin',
      data: pinData.toJson(),
      options: _createChildTokenWithDeviceOptions(pinData.deviceInfo),
    );
    await _saveChildSessionData(result);
    return result;
  }

  @override
  Future<AuthResult> authenticateChildWithPin(ChildPinAuth pinAuth) async {
    final result = await _performAuthApiCall(
      '$_familyChildPrefix/login',
      data: pinAuth.toJson(),
      options: _createChildTokenWithDeviceOptions(pinAuth.deviceInfo),
    );
    await _saveChildSessionData(result);
    return result;
  }

  @override
  Future<List<ChildModel>> getChildrenForDevice(
      String deviceFingerprint) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '$_familyChildPrefix/profiles',
      options: _createChildTokenOptions(
        headers: {'X-Device-Fingerprint': deviceFingerprint},
      ),
    );

    final data = response['data'] as Map<String, dynamic>;
    final childrenList = data['children'] as List<dynamic>;
    return childrenList
        .map((child) => ChildModel.fromJson(child as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getFamilyInfo() async {
    return await apiClient.get<Map<String, dynamic>>(_familyPrefix);
  }

  @override
  Future<ChildModel> addChild(String nickname, DateTime birthDate) async {
    return _addChildInternal(nickname, birthDate);
  }

  @override
  Future<ChildModel> addChildWithPin(
      String nickname, DateTime birthDate, String pin) async {
    return _addChildInternal(nickname, birthDate, pin: pin);
  }

  Future<ChildModel> _addChildInternal(
    String nickname,
    DateTime birthDate, {
    String? pin,
  }) async {
    final deviceHeaders = await _getDeviceHeadersSafely();
    final data = {
      'nickname': nickname,
      'birth_date': _formatDateForApi(birthDate),
      if (pin != null) 'pin': pin,
    };

    final response = await apiClient.post<Map<String, dynamic>>(
      '$_familyPrefix/children',
      data: data,
      options: deviceHeaders != null ? Options(headers: deviceHeaders) : null,
    );

    final responseData = response['data'] as Map<String, dynamic>;
    final childData = responseData['child'] as Map<String, dynamic>;
    return ChildModel.fromJson(childData);
  }

  @override
  Future<ChildModel> updateChild(int childId,
      {String? nickname, DateTime? birthDate}) async {
    final data = <String, dynamic>{
      if (nickname != null) 'nickname': nickname,
      if (birthDate != null) 'birth_date': _formatDateForApi(birthDate),
    };

    final response = await apiClient.put<Map<String, dynamic>>(
      '$_familyPrefix/children/$childId',
      data: data,
    );

    final responseData = response['data'] as Map<String, dynamic>;
    final childData = responseData['child'] as Map<String, dynamic>;
    return ChildModel.fromJson(childData);
  }

  @override
  Future<JoinCode> generateJoinCode(int childId) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '$_familyPrefix/children/$childId/join-code',
    );

    final data = response['data'] as Map<String, dynamic>;
    return JoinCode.fromJson(data);
  }

  Future<JoinCode> generateJoinCodeWithNickname(
      int childId, String childNickname) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '$_familyPrefix/children/$childId/join-code',
    );

    final data = response['data'] as Map<String, dynamic>;
    return JoinCode.fromJson(data, childNickname: childNickname);
  }

  @override
  Future<void> removeChild(int childId) async {
    await apiClient.delete('$_familyPrefix/children/$childId');
  }

  @override
  Future<UserModel> validateParentToken(String token) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '$_familyAuthPrefix/validate-token',
      options: Options(headers: _createBearerTokenHeader(token)),
    );

    final data = response['data'] as Map<String, dynamic>;
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  @override
  Future<ChildModel> validateChildSession(String sessionToken) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '$_familyPrefix/children/validate-session',
      options: _createChildTokenOptions(
        headers: _createBearerTokenHeader(sessionToken),
      ),
    );

    final data = response['data'] as Map<String, dynamic>;
    return ChildModel.fromJson(data['child'] as Map<String, dynamic>);
  }

  @override
  Future<String> refreshSession() async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '$_familyAuthPrefix/refresh',
    );
    final data = response['data'] as Map<String, dynamic>;
    final newToken = data['token'] as String;

    await tokenManager.saveToken(newToken);
    return newToken;
  }

  @override
  Future<void> logout() async {
    final token = await tokenManager.getToken();

    if (token != null) {
      await apiClient.post(
        '$_familyAuthPrefix/logout',
        options: Options(headers: _createBearerTokenHeader(token)),
      );
    } else {
      await apiClient.post('$_familyAuthPrefix/logout');
    }

    await _clearAuthenticationData();
  }

  @override
  Future<void> logoutChild() async {
    final childSessionToken = _storage.read(_childSessionTokenKey) as String?;

    _debugLog('Child logout - token exists: ${childSessionToken != null}');
    if (childSessionToken != null) {
      _debugLog('Child logout - token length: ${childSessionToken.length}');
    }

    if (childSessionToken != null) {
      await apiClient.post(
        '$_familyChildPrefix/logout',
        options: _createChildTokenOptions(
          headers: _createBearerTokenHeader(childSessionToken),
        ),
      );
    } else {
      _debugLog('Child logout - no token found, calling without auth');
      await apiClient.post('$_familyChildPrefix/logout');
    }

    await _clearChildSessionData();
  }

  @override
  Future<void> registerDevice(String deviceFingerprint, int familyId) async {
    await apiClient.post(
      '$_familyPrefix/$familyId/register-device',
      data: {'device_fingerprint': deviceFingerprint},
    );
  }

  @override
  Future<void> unregisterDevice(String deviceFingerprint) async {
    await apiClient.post(
      '$_familyPrefix/devices/unregister',
      data: {'device_fingerprint': deviceFingerprint},
    );
  }

  @override
  Future<DeviceMode> getDeviceMode(int familyId) async {
    final response = await apiClient
        .get<Map<String, dynamic>>('$_familyPrefix/$familyId/device-mode');
    final data = response['data'] as Map<String, dynamic>;
    return DeviceMode.fromString(data['device_mode'] as String);
  }

  @override
  Future<void> updateDeviceMode(int familyId, DeviceMode deviceMode) async {
    await apiClient.put(
      '$_familyPrefix/$familyId/device-mode',
      data: {'device_mode': deviceMode.value},
    );
  }

  @override
  Future<Map<String, dynamic>> loginStudent(
      String email, String password) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '$_familyAuthPrefix/login',
      data: {'email': email, 'password': password},
    );

    await _saveTokenFromResponse(response);
    return response;
  }

  @override
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
    String dateOfBirth,
  ) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '$_familyAuthPrefix/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'device_mode': 'single_device',
      },
    );

    await _saveTokenFromResponse(response);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    return await apiClient.get<Map<String, dynamic>>('$_familyAuthPrefix/me');
  }

  Future<void> _saveAuthenticationData(AuthResult result) async {
    if (result.token != null) {
      await tokenManager.saveToken(result.token!);
    }

    if (result.user != null) {
      await _storage.write(_userDataKey, result.user!.toJson());
    }

    if (result.family != null) {
      await _storage.write(_familyDataKey, result.family!.toJson());
    }
  }

  Future<void> _saveChildSessionData(AuthResult result) async {
    final childToken = result.sessionToken ?? result.token;

    _debugLog(
        'Saving child session - sessionToken: ${result.sessionToken != null}');
    _debugLog('Saving child session - token: ${result.token != null}');
    _debugLog('Saving child session - final childToken: ${childToken != null}');

    if (childToken != null) {
      await _storage.write(_childSessionTokenKey, childToken);
      _debugLog('Child token saved successfully');
    } else {
      _debugLog('No child token to save!');
    }

    if (result.child != null) {
      await _storage.write(_currentChildKey, result.child!.toJson());
      await _storage.write(_lastLoggedInChildIdKey, result.child!.id);
    }
  }

  Future<void> _clearAuthenticationData() async {
    await tokenManager.clearToken();
    await _storage.remove(_userDataKey);
    await _storage.remove(_familyDataKey);
    await _storage.remove(_tempTokenKey);
    await _clearChildSessionData();
  }

  Future<void> _clearChildSessionData() async {
    await _storage.remove(_childSessionTokenKey);
    await _storage.remove(_currentChildKey);
    await _storage.remove(_provisionalTokenKey);
  }

  Future<void> _saveTokenFromResponse(Map<String, dynamic> response) async {
    final data = response['data'] as Map<String, dynamic>?;
    final token = data?['token'] as String?;
    final user = data?['user'] as Map<String, dynamic>?;
    final isStudent = data?['is_student'] as bool?;

    if (token != null && token.isNotEmpty) {
      await tokenManager.saveToken(token);
    }

    if (user != null) {
      await _storage.write(_userNameKey, user['name']);
      await _storage.write(_userEmailKey, user['email']);
      await _storage.write(_isStudentKey, isStudent ?? false);
    }
  }
}
