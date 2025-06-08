import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';
import 'package:prism/core/util/entities/pagination_entity.dart';

class PaginatedCommentsEntity extends Equatable {
  final List<CommentEntity> comments;
  final PaginationEntity pagination;

  const PaginatedCommentsEntity({
    required this.comments,
    required this.pagination,
  });

  @override
  List<Object> get props => [comments, pagination];
}
