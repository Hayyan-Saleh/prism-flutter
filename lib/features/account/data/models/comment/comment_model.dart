import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.text,
    required super.likesCount,
    required super.repliesCount,
    required super.isLiked,
    required super.createdAt,
    required super.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    try {
      return CommentModel(
        id: json['id'] as int,
        text: json['text'] as String,
        likesCount: json['likes_count'] as int? ?? 0,
        repliesCount: json['replies_count'] as int? ?? 0,
        isLiked: json['is_liked'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
        user: SimplifiedAccountModel.fromJson(
          json['user'] as Map<String, dynamic>,
        ),
      );
    } catch (e, stack) {
      print('❌ Error in CommentModel.fromJson: $e');
      print('Stack: $stack');
      print('JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'likes_count': likesCount,
      'replies_count': repliesCount,
      'is_liked': isLiked,
      'created_at': createdAt.toIso8601String(),
      'user':
          SimplifiedAccountModel(
            id: user.id,
            fullName: user.fullName,
            accountName: user.accountName,
            avatar: user.avatar,
            followingStatus: user.followingStatus,
            isPrivate: user.isPrivate,
            role: user.role,
          ).toJson(),
    };
  }
}
