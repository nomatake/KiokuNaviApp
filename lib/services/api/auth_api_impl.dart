import 'package:kioku_navi/services/api/auth_api.dart';
import 'package:kioku_navi/services/api/base_api_client.dart';

class AuthApiImpl implements AuthApi {
  final BaseApiClient apiClient;

  AuthApiImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> loginStudent(
      String email, String password) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/api/auth/student/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return response;
  }

  @override
  Future<Map<String, dynamic>> loginParent(
      String email, String password) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/api/auth/parent/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return response;
  }

  @override
  Future<void> logout() async {
    await apiClient.post('/api/auth/logout');
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '/api/auth/user',
    );

    return response;
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/api/auth/refresh',
      data: {
        'refresh_token': refreshToken,
      },
    );

    return response;
  }
}
