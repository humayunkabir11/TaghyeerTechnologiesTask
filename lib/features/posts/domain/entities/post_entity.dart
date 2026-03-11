class PostEntity {
  final int? id;
  final String? title;
  final String? body;
  final List<String>? tags;
  final int? reactions;

  PostEntity({
    this.id,
    this.title,
    this.body,
    this.tags,
    this.reactions,
  });
}

class PostResponseEntity {
  final List<PostEntity>? posts;
  final int? total;
  final int? skip;
  final int? limit;

  PostResponseEntity({
    this.posts,
    this.total,
    this.skip,
    this.limit,
  });
}
