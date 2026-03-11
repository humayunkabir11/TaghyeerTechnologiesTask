import 'package:taghyeer_task/core/config/strings/api_endpoint.dart';

import '../../../../core/error/server_exception.dart';
import '../../../../core/network/api_client.dart';

abstract class PostsRemoteDataSource {
  Future<Map<String, dynamic>> getPosts({int limit = 10, int skip = 0});
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final ApiClient apiClient;

  PostsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> getPosts({int limit = 10, int skip = 0}) async {
    try {
      final response = await apiClient.get(
        api: ApiEndpoint.posts,
        params: {'limit': limit, 'skip': skip},
      );
      return response.data;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
