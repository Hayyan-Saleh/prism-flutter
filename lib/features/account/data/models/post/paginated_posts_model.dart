import 'package:prism/core/util/models/pagination_model.dart';
import 'package:prism/features/account/data/models/post/post_model.dart';
import 'package:prism/features/account/domain/enitities/post/post_pagination_entity.dart'; 

class PaginatedPostsModel extends PaginatedPostsEntity {
  const PaginatedPostsModel({
    required super.posts,
    required super.pagination,
  });

  factory PaginatedPostsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedPostsModel(
      posts: (json['posts'] as List<dynamic>)
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': (posts as List<PostModel>).map((e) => e.toJson()).toList(), // Cast to PostModel
      'pagination': (pagination as PaginationModel).toJson(), // Cast to PaginationModel
    };
  }
}