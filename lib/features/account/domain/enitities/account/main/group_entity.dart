import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/main/join_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class GroupEntity extends Equatable {
  final int id;
  final String name;
  final String privacy;
  final SimplifiedAccountEntity owner;
  final JoinStatus joinStatus;
  final String? avatar;
  final String? bio;
  final int? membersCount;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.privacy,
    required this.owner,
    required this.joinStatus,
    this.avatar,
    this.bio,
    this.membersCount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    privacy,
    owner,
    avatar,
    joinStatus,
    bio,
    membersCount,
    joinStatus,
  ];
}
