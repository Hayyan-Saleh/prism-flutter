import 'package:prism/core/util/models/pagination_model.dart';
import 'package:prism/features/account/data/models/comment/comment_model.dart';
import 'package:prism/features/account/domain/enitities/comment/paginated_comment_entity.dart';

class PaginatedCommentsModel extends PaginatedCommentsEntity {
  const PaginatedCommentsModel({
    required super.comments,
    required super.pagination,
  });

  factory PaginatedCommentsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedCommentsModel(
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comments': (comments as List<CommentModel>)
          .map((e) => e.toJson())
          .toList(),
      'pagination': (pagination as PaginationModel).toJson(),
    };
  }
}
