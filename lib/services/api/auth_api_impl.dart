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

  AuthApiImpl({
    required this.apiClient,
    required this.tokenManager,
    GetStorage? storage,
  }) : _storage = storage ?? GetStorage();

  // === Parent Authentication Methods ===

  @override
  Future<Map<String, dynamic>> preRegisterParent(String email) async {
    return await apiClient.post<Map<String, dynamic>>(
      'family/auth/pre-register',
      data: {'email': email},
    );
  }

  @override
  Future<AuthResult> verifyEmail(String email, String otp) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'family/auth/verify-email',
      data: {
        'email': email,
        'otp': otp,
      },
    );

    final result = AuthResult.fromJson(response);

    // Store temporary token if provided
    if (result.provisionalToken != null) {
      await _storage.write('temp_token', result.provisionalToken);
    }

    return result;
  }

  @override
  Future<AuthResult> completeParentProfile(
      ParentProfileCompletion profileData) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'family/auth/complete-profile',
      data: profileData.toJson(),
    );

    final result = AuthResult.fromJson(response);

    // Save authentication data after successful profile completion
    await _saveAuthenticationData(result);

    return result;
  }

  @override
  Future<AuthResult> loginParent(String email, String password) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'family/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final result = AuthResult.fromJson(response);

    // Save authentication data after successful login
    await _saveAuthenticationData(result);

    return result;
  }

  // === Child Authentication Methods ===

  @override
  Future<AuthResult> joinWithCode(ChildJoinRequest request) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'family/children/join',
      data: request.toJson(),
      options: Options(headers: request.deviceInfo.toHeaders()),
    );

    final result = AuthResult.fromJson(response);

    // Store provisional token for PIN setup
    if (result.provisionalToken != null) {
      await _storage.write('provisional_token', result.provisionalToken);
    }

    return result;
  }

  @override
  Future<AuthResult> setChildPin(ChildPinSetup pinData) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'family/children/set-pin',
      data: pinData.toJson(),
    );

    final result = AuthResult.fromJson(response);

    // Save child session data
    await _saveChildSessionData(result);

    return result;
  }

  @override
  Future<AuthResult> authenticateChildWithPin(ChildPinAuth pinAuth) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'family/children/auth/pin',
      data: pinAuth.toJson(),
      options: Options(headers: pinAuth.deviceInfo.toHeaders()),
    );

    final result = AuthResult.fromJson(response);

    // Save child session data
    await _saveChildSessionData(result);

    return result;
  }

  @override
  Future<List<ChildModel>> getChildrenForDevice(
      String deviceFingerprint) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'family/children/profiles',
      options: Options(headers: {'X-Device-Fingerprint': deviceFingerprint}),
    );

    final data = response['data'] as List<dynamic>;
    return data
        .map((child) => ChildModel.fromJson(child as Map<String, dynamic>))
        .toList();
  }

  // === Family Management Methods ===

  @override
  Future<Map<String, dynamic>> getFamilyInfo() async {
    return await apiClient.get<Map<String, dynamic>>('families');
  }

  @override
  Future<ChildModel> addChild(String nickname, DateTime birthDate) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'family/children',
      data: {
        'nickname': nickname,
        'birth_date':
            birthDate.toIso8601String().split('T')[0], // YYYY-MM-DD format
      },
    );

    final data = response['data'] as Map<String, dynamic>;
    return ChildModel.fromJson(data);
  }

  @override
  Future<ChildModel> updateChild(int childId,
      {String? nickname, DateTime? birthDate}) async {
    final data = <String, dynamic>{};
    if (nickname != null) data['nickname'] = nickname;
    if (birthDate != null)
      data['birth_date'] = birthDate.toIso8601String().split('T')[0];

    final response = await apiClient.put<Map<String, dynamic>>(
      'family/children/$childId',
      data: data,
    );

    final responseData = response['data'] as Map<String, dynamic>;
    return ChildModel.fromJson(responseData);
  }

  @override
  Future<JoinCode> generateJoinCode(int childId) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'family/children/$childId/join-code',
    );

    final data = response['data'] as Map<String, dynamic>;
    return JoinCode.fromJson(data);
  }

  @override
  Future<void> removeChild(int childId) async {
    await apiClient.delete('family/children/$childId');
  }

  // === Session Management Methods ===

  @override
  Future<UserModel> validateParentToken(String token) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'family/auth/validate-token',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response['data'] as Map<String, dynamic>;
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  @override
  Future<ChildModel> validateChildSession(String sessionToken) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'family/children/validate-session',
      options: Options(headers: {'Authorization': 'Bearer $sessionToken'}),
    );

    final data = response['data'] as Map<String, dynamic>;
    return ChildModel.fromJson(data['child'] as Map<String, dynamic>);
  }

  @override
  Future<String> refreshSession() async {
    final response =
        await apiClient.post<Map<String, dynamic>>('family/auth/refresh');
    final data = response['data'] as Map<String, dynamic>;
    final newToken = data['token'] as String;

    // Update stored token
    await tokenManager.saveToken(newToken);

    return newToken;
  }

  @override
  Future<void> logout() async {
    await apiClient.get('family/auth/logout');
    await _clearAuthenticationData();
  }

  @override
  Future<void> logoutChild() async {
    await apiClient.post('family/children/logout');
    await _clearChildSessionData();
  }

  // === Device Management ===

  @override
  Future<void> registerDevice(String deviceFingerprint, int familyId) async {
    await apiClient.post(
      'family/$familyId/register-device',
      data: {'device_fingerprint': deviceFingerprint},
    );
  }

  @override
  Future<void> unregisterDevice(String deviceFingerprint) async {
    await apiClient.post(
      'family/devices/unregister',
      data: {'device_fingerprint': deviceFingerprint},
    );
  }

  @override
  Future<DeviceMode> getDeviceMode(int familyId) async {
    final response = await apiClient
        .get<Map<String, dynamic>>('family/$familyId/device-mode');
    final data = response['data'] as Map<String, dynamic>;
    return DeviceMode.fromString(data['device_mode'] as String);
  }

  @override
  Future<void> updateDeviceMode(int familyId, DeviceMode deviceMode) async {
    await apiClient.put(
      'family/$familyId/device-mode',
      data: {'device_mode': deviceMode.value},
    );
  }

  // === Legacy Methods (for backward compatibility) ===

  @override
  Future<Map<String, dynamic>> loginStudent(
      String email, String password) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'family/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    // Automatically save token after successful login
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
      'family/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'date_of_birth': dateOfBirth,
      },
    );

    return response;
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response =
        await apiClient.get<Map<String, dynamic>>('family/auth/me');
    return response;
  }

  // === Private Helper Methods ===

  /// Save authentication data after successful parent authentication
  Future<void> _saveAuthenticationData(AuthResult result) async {
    if (result.token != null) {
      await tokenManager.saveToken(result.token!);
    }

    if (result.user != null) {
      await _storage.write('user_data', result.user!.toJson());
    }

    if (result.family != null) {
      await _storage.write('family_data', result.family!.toJson());
    }
  }

  /// Save child session data after successful child authentication
  Future<void> _saveChildSessionData(AuthResult result) async {
    if (result.sessionToken != null) {
      await _storage.write('child_session_token', result.sessionToken);
    }

    if (result.child != null) {
      await _storage.write('current_child', result.child!.toJson());
      await _storage.write('last_logged_in_child_id', result.child!.id);
    }
  }

  /// Clear all authentication data
  Future<void> _clearAuthenticationData() async {
    await tokenManager.clearToken();
    await _storage.remove('user_data');
    await _storage.remove('family_data');
    await _storage.remove('temp_token');
    await _clearChildSessionData();
  }

  /// Clear child session data
  Future<void> _clearChildSessionData() async {
    await _storage.remove('child_session_token');
    await _storage.remove('current_child');
    await _storage.remove('provisional_token');
  }

  /// Legacy helper to extract and save token from API response
  Future<void> _saveTokenFromResponse(Map<String, dynamic> response) async {
    final data = response['data'] as Map<String, dynamic>?;
    final token = data?['token'] as String?;
    final user = data?['user'] as Map<String, dynamic>?;
    final isStudent = data?['is_student'] as bool?;

    if (token != null && token.isNotEmpty) {
      await tokenManager.saveToken(token);
    }

    if (user != null) {
      await _storage.write('user_name', user['name']);
      await _storage.write('user_email', user['email']);
      await _storage.write('is_student', isStudent ?? false);
    }
  }
}
