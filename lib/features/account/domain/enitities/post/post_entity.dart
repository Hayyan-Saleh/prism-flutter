import 'package:equatable/equatable.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class PostEntity extends Equatable {
  final int id;
  final String? text;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isSaved;
  final int? groupId;
  final List<MediaEntity> media;
  final String privacy;
  final DateTime createdAt;
  final SimplifiedAccountEntity user;

  const PostEntity({
    required this.id,
    this.text,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isSaved,
    this.groupId,
    required this.media,
    required this.privacy,
    required this.createdAt,
    required this.user,
  });

  PostEntity copyWith({
    int? id,
    String? text,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isSaved,
    int? groupId,
    List<MediaEntity>? media,
    String? privacy,
    DateTime? createdAt,
    SimplifiedAccountEntity? user,
  }) {
    return PostEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      groupId: groupId ?? this.groupId,
      media: media ?? this.media,
      privacy: privacy ?? this.privacy,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    likesCount,
    commentsCount,
    isLiked,
    isSaved,
    groupId,
    media,
    privacy,
    createdAt,
    user,
  ];
}
