import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class CommentEntity extends Equatable {
  final int id;
  final String text;
  final int likesCount;
  final int repliesCount;
  final bool isLiked;
  final DateTime createdAt;
  final SimplifiedAccountEntity user;

  /// قائمة الردود التابعة لهذا التعليق
  final List<CommentEntity> replies;

  /// هل الردود معروضة في الواجهة أم لا
  final bool areRepliesVisible;

  const CommentEntity({
    required this.id,
    required this.text,
    required this.likesCount,
    required this.repliesCount,
    required this.isLiked,
    required this.createdAt,
    required this.user,
    this.replies = const [], // افتراضي: لا ردود
    this.areRepliesVisible = false, // افتراضي: الردود غير معروضة
  });

  CommentEntity copyWith({
    int? id,
    String? text,
    int? likesCount,
    int? repliesCount,
    bool? isLiked,
    DateTime? createdAt,
    SimplifiedAccountEntity? user,
    List<CommentEntity>? replies,
    bool? areRepliesVisible,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      likesCount: likesCount ?? this.likesCount,
      repliesCount: repliesCount ?? this.repliesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      replies: replies ?? this.replies,
      areRepliesVisible: areRepliesVisible ?? this.areRepliesVisible,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        likesCount,
        repliesCount,
        isLiked,
        createdAt,
        user,
        replies,
        areRepliesVisible, // ✨ مهم: نضيفه للمقارنة
      ];
}
