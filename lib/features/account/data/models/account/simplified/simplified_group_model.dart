import 'package:prism/features/account/domain/enitities/account/main/account_role.dart';
import 'package:prism/features/account/domain/enitities/account/main/join_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_group_entity.dart';

class SimplifiedGroupModel extends SimplifiedGroupEntity {
  const SimplifiedGroupModel({
    required super.id,
    required super.name,
    required super.privacy,
    required super.joinStatus,
    super.role,
    super.avatar,
    super.bio,
    super.membersCount,
  });

  factory SimplifiedGroupModel.fromJson(Map<String, dynamic> json) {
    final JoinStatus joinStatus;
    switch (json['join_status']) {
      case 'joined':
        joinStatus = JoinStatus.joined;
        break;
      case 'pending':
        joinStatus = JoinStatus.pending;
        break;
      default: //'not_joined'
        joinStatus = JoinStatus.notJoined;
    }

    AccountRole? role;
    if (json['role'] != null) {
      switch (json['role']) {
        case 'owner':
          role = AccountRole.owner;
          break;
        case 'admin':
          role = AccountRole.admin;
          break;
        case 'member':
          role = AccountRole.member;
          break;
      }
    }

    return SimplifiedGroupModel(
      id: json['id'],
      name: json['name'],
      privacy: json['privacy'],
      avatar: json['avatar'],
      joinStatus: joinStatus,
      bio: json['bio'],
      membersCount: json['members_count'],
      role: role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'privacy': privacy,
      'join_status': joinStatus.name,
      'avatar': avatar,
      'bio': bio,
      'members_count': membersCount,
      'role': role?.name,
    };
  }
}

