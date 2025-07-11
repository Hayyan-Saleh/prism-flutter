import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class FollowRequestEntity extends Equatable {
  final int id;
  final SimplifiedAccountEntity creator;

  const FollowRequestEntity({
    required this.id,
    required this.creator,
  });

  @override
  List<Object?> get props => [id, creator];
}
