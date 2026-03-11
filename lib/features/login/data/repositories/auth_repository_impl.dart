import 'package:taghyeer_task/core/network/api_client.dart';
import 'package:taghyeer_task/features/login/domain/repositories/auth_repository.dart';
import 'package:taghyeer_task/features/login/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl(this.apiClient);

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await apiClient.post(
      api: '/auth/login',
      body: {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      },
    );
    return UserModel.fromJson(response.data);
  }
}
