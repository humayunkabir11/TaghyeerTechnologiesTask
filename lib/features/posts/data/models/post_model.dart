import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  PostModel({
    super.id,
    super.title,
    super.body,
    super.tags,
    super.reactions,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    int? reactionCount;
    if (json['reactions'] is Map) {
      reactionCount = (json['reactions']['likes']);
    } else if (json['reactions'] is int) {
      reactionCount = json['reactions'];
    }

    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      reactions: reactionCount,
    );
  }
}

class PostResponse extends PostResponseEntity {
  PostResponse({
    List<PostModel>? posts,
    super.total,
    super.skip,
    super.limit,
  }) : super(posts: posts);

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      posts: json['posts'] != null
          ? (json['posts'] as List).map((i) => PostModel.fromJson(i)).toList()
          : null,
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }
}
