import 'package:prism/core/util/models/media_model.dart';
import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';

class StatusModel extends StatusEntity {
  const StatusModel({
    required super.id,
    required super.text,
    required super.expirationDate,
    required super.privacy,
    super.media,
    required super.createdAt,
    required super.user,
    required super.likesCount,
    required super.isLiked,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
    id: json['id'] as int,
    text: json['text'] as String?,
    expirationDate: DateTime.parse(json['expiration_date'] as String),
    privacy: json['privacy'] as String,
    media:
        json['media'] != null
            ? MediaModel.fromJson(json['media'] as Map<String, dynamic>)
            : null,
    createdAt: DateTime.parse(json['created_at'] as String),
    user: SimplifiedAccountModel.fromJson(json['user'] as Map<String, dynamic>),
    likesCount: json['likes_count'] as int? ?? 0,
    isLiked: json['is_liked'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'expiration_date': expirationDate.toIso8601String(),
    'privacy': privacy,
    'media': (media as MediaModel?)?.toJson(),
    'created_at': createdAt.toIso8601String(),
    'user': (user as SimplifiedAccountModel).toJson(),
    'likes_count': likesCount,
    'is_liked': isLiked,
  };
}
