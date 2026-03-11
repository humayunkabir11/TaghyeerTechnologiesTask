import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostsUseCase implements UseCase<PostResponseEntity, GetPostsParams> {
  final PostsRepository postsRepository;

  GetPostsUseCase(this.postsRepository);

  @override
  Future<Either<Failure, PostResponseEntity>> call(GetPostsParams params) async {
    try {
      final postsResponse = await postsRepository.getPosts(
        limit: params.limit,
        skip: params.skip,
      );
      return Right(postsResponse);
    } catch (e) {
      return Left(Failure.serverError(e.toString()));
    }
  }
}

class GetPostsParams {
  final int limit;
  final int skip;

  GetPostsParams({this.limit = 10, this.skip = 0});
}
