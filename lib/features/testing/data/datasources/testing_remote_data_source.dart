
import '../../../../core/error/server_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/config/strings/api_endpoint.dart';
import '../../domain/usecase/testing_usecase.dart';
import '../../../../core/common/models/success_response.dart';

abstract class TestingRemoteDataSource {
    Future<SuccessResponse?> login(GetTestingParams params);
}

class TestingRemoteSourceImpl implements TestingRemoteDataSource {
  final ApiClient apiClient;
  TestingRemoteSourceImpl({required this.apiClient});

  @override
  Future<SuccessResponse?> login(GetTestingParams params) async {
    // TODO: implement login
    try {
      final result = await apiClient.post(
          api: ApiEndpoint.login,
          body: params.body ?? {}
      );
      return SuccessResponse.fromJson(result.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}