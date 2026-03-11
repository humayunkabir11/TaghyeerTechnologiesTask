import '../datasources/posts_remote_data_source.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/entities/post_entity.dart';
import '../models/post_model.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;

  PostsRepositoryImpl(this.remoteDataSource);

  @override
  Future<PostResponseEntity> getPosts({int limit = 10, int skip = 0}) async {
    final responseData = await remoteDataSource.getPosts(limit: limit, skip: skip);
    return PostResponse.fromJson(responseData);
  }
}
