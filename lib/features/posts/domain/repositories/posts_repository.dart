
import '../entities/post_entity.dart';

abstract class PostsRepository {
  Future<PostResponseEntity> getPosts({int limit = 10, int skip = 0});
}
