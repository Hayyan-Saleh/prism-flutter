class CommentEntity {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final List<String> likes;
  final String? parentCommentId;
  
  const CommentEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.likes,
    this.parentCommentId,
  });

  CommentEntity copyWith({
    String? id,
    String? postId,
    String? userId,
    String? content,
    DateTime? createdAt,
    List<String>? likes,
    String? parentCommentId,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }

  bool isLikedByUser(String userId) => likes.contains(userId);
}