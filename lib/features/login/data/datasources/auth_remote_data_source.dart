
import '../../../../core/error/server_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/config/strings/api_endpoint.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await apiClient.post(
        api: ApiEndpoint.login,
        body: {
          'username': username,
          'password': password,
          'expiresInMins': 30,
        },
      );
      return response.data;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
