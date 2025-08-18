import 'package:prism/core/util/models/media_model.dart';
import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/domain/enitities/post/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    super.text,
    required super.likesCount,
    required super.commentsCount,
    required super.isLiked,
    required super.isSaved,
    super.groupId,
    required super.media,
    required super.privacy,
    required super.createdAt,
    required super.user,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    try {
      return PostModel(
        id: json['id'] as int,
        text: json['text'] as String?,
        likesCount: json['likes_count'] as int? ?? 0,
        commentsCount: json['comments_count'] as int? ?? 0,
        isLiked: json['is_liked'] as bool? ?? false,
        isSaved: json['is_saved'] as bool? ?? true,
        groupId: json['group_id'] != null ? json['group_id'] as int : null,
        media:
            (json['media'] as List<dynamic>?)
                ?.map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        privacy: json['privacy']?.toString() ?? 'public', // ← هنا التحسين
        createdAt: DateTime.parse(json['created_at'] as String),
        user: SimplifiedAccountModel.fromJson(
          json['user'] as Map<String, dynamic>,
        ),
      );
    } catch (e, stack) {
      print('❌ Error in PostModel.fromJson: $e');
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
      'comments_count': commentsCount,
      'is_liked': isLiked,
      'is_saved': isSaved,
      'group_id': groupId,
      'media':
          media
              .map(
                (e) => MediaModel(id: e.id, type: e.type, url: e.url).toJson(),
              )
              .toList(),
      'privacy': privacy,
      'created_at': createdAt.toIso8601String(),
      'user':
          SimplifiedAccountModel(
            id: user.id,
            fullName: user.fullName,
            accountName: user.accountName,
            avatar: user.avatar,
            followingStatus: user.followingStatus,
            isPrivate: user.isPrivate,
          ).toJson(),
    };
  }
}
