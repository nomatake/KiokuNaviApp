import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';
import 'package:kioku_navi/services/auth/token_manager.dart';

class AuthApiImpl implements AuthApi {
  final BaseApiClient apiClient;
  final TokenManager tokenManager;

  AuthApiImpl({
    required this.apiClient,
    required this.tokenManager,
  });

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

    // Automatically save token after successful registration
    await _saveTokenFromResponse(response);

    return response;
  }

  @override
  Future<void> logout() async {
    await apiClient.get('auth/logout');

    // Automatically clear token after successful logout
    await tokenManager.clearToken();
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'auth/me',
    );

    return response;
  }

  @override
  Future<Map<String, dynamic>> refreshToken() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'auth/refresh',
    );

    // Automatically save new token after successful refresh
    await _saveTokenFromResponse(response);

    return response;
  }

  /// Private helper to extract and save token from API response
  Future<void> _saveTokenFromResponse(Map<String, dynamic> response) async {
    final data = response['data'] as Map<String, dynamic>?;
    final token = data?['token'] as String?;

    if (token != null && token.isNotEmpty) {
      await tokenManager.saveToken(token);
    }
  }
}
