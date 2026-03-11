class PostModel {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int reactions;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    // Reactions can be object or int depending on API version
    int reactionCount = 0;
    if (json['reactions'] is Map) {
      reactionCount = (json['reactions']['likes'] ?? 0);
    } else if (json['reactions'] is int) {
      reactionCount = json['reactions'];
    }

    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      tags: List<String>.from(json['tags'] ?? []),
      reactions: reactionCount,
    );
  }
}

class PostResponse {
  final List<PostModel> posts;
  final int total;
  final int skip;
  final int limit;

  PostResponse({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      posts: (json['posts'] as List).map((i) => PostModel.fromJson(i)).toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }
}
