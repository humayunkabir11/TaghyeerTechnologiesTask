
import 'package:taghyeer_task/features/posts/data/models/post_model.dart';

abstract class PostsRepository {
  Future<PostResponse> getPosts({int limit = 10, int skip = 0});
}
