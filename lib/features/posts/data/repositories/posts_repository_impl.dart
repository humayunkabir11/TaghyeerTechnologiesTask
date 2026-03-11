import 'package:taghyeer_task/core/network/api_client.dart';
import 'package:taghyeer_task/features/posts/domain/repositories/posts_repository.dart';
import 'package:taghyeer_task/features/posts/data/models/post_model.dart';

class PostsRepositoryImpl implements PostsRepository {
  final ApiClient apiClient;
  PostsRepositoryImpl(this.apiClient);

  @override
  Future<PostResponse> getPosts({int limit = 10, int skip = 0}) async {
    final response = await apiClient.get(
      api: '/posts',
      params: {'limit': limit, 'skip': skip},
    );
    return PostResponse.fromJson(response.data);
  }
}
