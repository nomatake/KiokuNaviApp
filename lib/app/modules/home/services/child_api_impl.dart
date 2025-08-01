import 'package:kioku_navi/services/api/base_api_client.dart';

import 'child_api.dart';

class ChildApiImpl implements ChildApi {
  final BaseApiClient apiClient;

  ChildApiImpl({
    required this.apiClient,
  });

  @override
  Future<Map<String, dynamic>> getChildHome() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      'child/home',
    );

    return response;
  }
}