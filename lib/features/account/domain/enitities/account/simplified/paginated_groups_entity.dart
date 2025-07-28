import 'package:prism/core/util/entities/pagination_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_group_entity.dart';

class PaginatedGroupsEntity {
  final List<SimplifiedGroupEntity> groups;
  final PaginationEntity? pagination;

  PaginatedGroupsEntity({required this.groups, this.pagination});
}
