import 'package:get_storage/get_storage.dart';
import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';

class AuthApiImpl implements AuthApi {
  final BaseApiClient apiClient;
  final TokenManager tokenManager;
  final GetStorage _storage;

  AuthApiImpl({
    required this.apiClient,
    required this.tokenManager,
    GetStorage? storage,
  }) : _storage = storage ?? GetStorage();

  @override
  Future<Map<String, dynamic>> loginStudent(
      String email, String password) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'auth/login',
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
  Future<Map<String, dynamic>> loginParent(
      String email, String password) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      'auth/login',
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
      'auth/register',
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
  Future<void> logout() async {
    await apiClient.get('auth/logout');

    // Automatically clear token and user data after successful logout
    await tokenManager.clearToken();
    _clearUserData();
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'auth/me',
    );

    return response;
  }

  /// Private helper to extract and save token from API response
  /// Also saves user data after successful authentication
  Future<void> _saveTokenFromResponse(Map<String, dynamic> response) async {
    final data = response['data'] as Map<String, dynamic>?;
    final token = data?['token'] as String?;
    final user = data?['user'] as Map<String, dynamic>?;
    final isStudent = data?['is_student'] as bool?;

    if (token != null && token.isNotEmpty) {
      // Save the authentication token
      await tokenManager.saveToken(token);
    }

    if (user != null) {
      // Save user data
      _storage.write('user_name', user['name']);
      _storage.write('user_email', user['email']);
      _storage.write('is_student', isStudent ?? false);
    }
  }

  /// Private helper to clear user data from storage
  void _clearUserData() {
    _storage.remove('user_name');
    _storage.remove('user_email');
    _storage.remove('is_student');
  }
}
