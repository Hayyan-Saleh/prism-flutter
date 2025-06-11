import 'package:prism/core/util/entities/pagination_entity.dart';

class PaginationModel extends PaginationEntity {
  PaginationModel({
    required super.currentPage,
    required super.perPage,
    required super.total,
    required super.lastPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      PaginationModel(
        currentPage: json['current_page'] as int? ?? 1,
        perPage: json['per_page'] as int? ?? 10,
        total: json['total'] as int? ?? 0,
        lastPage: json['last_page'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'per_page': perPage,
    'total': total,
    'last_page': lastPage,
  };
}
