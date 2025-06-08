import 'package:equatable/equatable.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class PostEntity extends Equatable {
  final int id;
  final String text;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final int? groupId;
  final List<MediaEntity> media;
  final String privacy;
  final DateTime createdAt;
  final SimplifiedAccountEntity user;

  const PostEntity({
    required this.id,
    required this.text,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    this.groupId,
    required this.media,
    required this.privacy,
    required this.createdAt,
    required this.user,
  });

  @override
  List<Object?> get props => [
    id,
    text,
    likesCount,
    commentsCount,
    isLiked,
    groupId,
    media,
    privacy,
    createdAt,
    user,
  ];
}
