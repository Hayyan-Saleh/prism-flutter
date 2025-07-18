import 'package:equatable/equatable.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class StatusEntity extends Equatable {
  final int id;
  final String? text;
  final DateTime expirationDate;
  final String privacy;
  final MediaEntity? media;
  final DateTime createdAt;
  final SimplifiedAccountEntity user;
  final int likesCount;
  final bool isLiked;

  const StatusEntity({
    required this.id,
    required this.text,
    required this.expirationDate,
    required this.privacy,
    this.media,
    required this.createdAt,
    required this.user,
    required this.likesCount,
    required this.isLiked,
  });

  StatusEntity copyWith({
    int? id,
    String? text,
    DateTime? expirationDate,
    String? privacy,
    MediaEntity? media,
    DateTime? createdAt,
    SimplifiedAccountEntity? user,
    int? likesCount,
    bool? isLiked,
  }) {
    return StatusEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      expirationDate: expirationDate ?? this.expirationDate,
      privacy: privacy ?? this.privacy,
      media: media ?? this.media,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
    id,
    text,
    expirationDate,
    privacy,
    media,
    createdAt,
    user,
    likesCount,
    isLiked,
  ];
}
