import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class GroupAccountEntity extends Equatable {
  final int id;
  final String name;
  final String privacy;
  final SimplifiedAccountEntity owner;
  final String? avatar;
  final String? bio;

  const GroupAccountEntity({
    required this.id,
    required this.name,
    required this.privacy,
    required this.owner,
    this.avatar,
    this.bio,
  });

  @override
  List<Object?> get props => [id, name, privacy, owner, avatar, bio];
}
