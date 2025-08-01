import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_group_entity.dart';

class JoinRequestEntity extends Equatable {
  final int id;
  final DateTime requestedAt;
  final SimplifiedAccountEntity creator;
  final SimplifiedGroupEntity? group;

  const JoinRequestEntity({
    required this.id,
    required this.requestedAt,
    required this.creator,
    required this.group,
  });

  @override
  List<Object?> get props => [id, requestedAt, creator, group];
}
