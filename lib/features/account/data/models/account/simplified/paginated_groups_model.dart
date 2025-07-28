import 'package:prism/core/util/models/pagination_model.dart';
import 'package:prism/features/account/data/models/account/simplified/simplified_group_model.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/paginated_groups_entity.dart';

class PaginatedGroupsModel extends PaginatedGroupsEntity {
  PaginatedGroupsModel({required super.groups, required super.pagination});

  factory PaginatedGroupsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedGroupsModel(
      groups:
          (json['groups']['data'] as List)
              .map((group) => SimplifiedGroupModel.fromJson(group))
              .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }
}
