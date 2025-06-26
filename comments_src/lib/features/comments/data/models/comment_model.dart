import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String name;
  final String avatar;
  final String content; // text
  final DateTime createdAt;
  final List<String> likes;
  final Int likes_count;
  final String? parentCommentId;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.name,
    required this.content,
    required this.createdAt,
    this.likes = const [],
    required this.likes_count,
    required this.avatar,
    this.parentCommentId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      name: json["name"] as String,
      avatar: json["avatar"] as String,
      likes_count: json["likes_count"] as Int,
      createdAt: (json['created_at'] as Timestamp).toDate(),
      likes: List<String>.from(json['likes'] as List<dynamic>? ?? []),
      parentCommentId: json['parentCommentId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'likes_count': likes_count,
      'name': name,
      'avatar': avatar,
      'parentCommentId': parentCommentId,
    };
  }

  CommentEntity toEntity() {
    return CommentEntity(
      id: id,
      postId: postId,
      userId: userId,
      content: content,
      createdAt: createdAt,
      likes: likes,
      avatar: avatar,
      likes_count: likes_count,
      name: name,
      parentCommentId: parentCommentId,
    );
  }

  factory CommentModel.fromEntity(CommentEntity entity) {
    return CommentModel(
      id: entity.id,
      postId: entity.postId,
      userId: entity.userId,
      content: entity.content,
      createdAt: entity.createdAt,
      likes: entity.likes,
      likes_count: entity.like_counts,
      avatar: entity.avatar,
      name: entity.name,
      parentCommentId: entity.parentCommentId,
    );
  }
}
