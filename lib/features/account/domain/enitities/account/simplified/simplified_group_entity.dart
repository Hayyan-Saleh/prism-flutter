import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_role.dart';
import 'package:prism/features/account/domain/enitities/account/main/join_status_enum.dart';

class SimplifiedGroupEntity extends Equatable {
  final int id;
  final String name;
  final String privacy;
  final JoinStatus joinStatus;
  final AccountRole? role;
  final String? avatar;
  final String? bio;
  final int? membersCount;

  const SimplifiedGroupEntity({
    required this.id,
    required this.name,
    required this.privacy,
    this.avatar,
    required this.joinStatus,
    this.role,
    this.bio,
    this.membersCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        privacy,
        avatar,
        bio,
        membersCount,
        joinStatus,
        role,
      ];
}

