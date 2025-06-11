import 'package:prism/core/util/models/pagination_model.dart';
import 'package:prism/features/account/data/models/simplified/simplified_account_model.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/paginated_simplified_account_entity.dart';

class PaginatedSimplifiedAccountModel extends PaginatedSimplifiedAccountEntity {
  const PaginatedSimplifiedAccountModel({
    required List<SimplifiedAccountModel> accounts,
    required PaginationModel pagination,
  }) : super(accounts: accounts, pagination: pagination);

  factory PaginatedSimplifiedAccountModel.fromJson(Map<String, dynamic> json) {
    return PaginatedSimplifiedAccountModel(
      accounts:
          (json['accounts'] as List)
              .map((account) => SimplifiedAccountModel.fromJson(account))
              .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accounts':
          (accounts as List<SimplifiedAccountModel>)
              .map((account) => account.toJson())
              .toList(),
      'pagination': (pagination as PaginationModel).toJson(),
    };
  }
}
