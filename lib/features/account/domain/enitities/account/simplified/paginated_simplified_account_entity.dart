import 'package:equatable/equatable.dart';
import 'package:prism/core/util/entities/pagination_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class PaginatedSimplifiedAccountEntity extends Equatable {
  final List<SimplifiedAccountEntity> accounts;
  final PaginationEntity pagination;

  const PaginatedSimplifiedAccountEntity({
    required this.accounts,
    required this.pagination,
  });

  @override
  List<Object?> get props => [accounts, pagination];
}
