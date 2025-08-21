import 'package:equatable/equatable.dart';
import 'package:prism/core/util/entities/pagination_entity.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';

class PaginatedCommentsEntity extends Equatable {
  final List<CommentEntity> comments;
  final PaginationEntity pagination;

  const PaginatedCommentsEntity({
    required this.comments,
    required this.pagination,
  });

  PaginatedCommentsEntity copyWith({
    List<CommentEntity>? comments,
    PaginationEntity? pagination,
  }) {
    return PaginatedCommentsEntity(
      comments: comments ?? this.comments,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object> get props => [comments, pagination];
}
