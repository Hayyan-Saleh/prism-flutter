import 'package:equatable/equatable.dart';
import 'package:prism/core/util/entities/pagination_entity.dart';
import 'package:prism/features/account/domain/enitities/post/post_entity.dart';

class PaginatedPostsEntity extends Equatable {
  final List<PostEntity> posts;
  final PaginationEntity pagination;

  const PaginatedPostsEntity({required this.posts, required this.pagination});

  @override
  List<Object> get props => [posts, pagination];
}
