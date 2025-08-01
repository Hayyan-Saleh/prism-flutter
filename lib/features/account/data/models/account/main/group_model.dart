import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_role.dart';
import 'package:prism/features/account/domain/enitities/account/main/group_entity.dart';
import 'package:prism/features/account/domain/enitities/account/main/join_status_enum.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.name,
    required super.privacy,
    required SimplifiedAccountModel super.owner,
    required super.joinStatus,
    super.role,
    super.avatar,
    super.bio,
    super.membersCount,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    final JoinStatus joinStatus;
    switch (json['join_status']) {
      case 'joined':
        joinStatus = JoinStatus.joined;
      case 'pending':
        joinStatus = JoinStatus.pending;
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
    return GroupModel(
      id: json['id'],
      name: json['name'],
      privacy: json['privacy'],
      owner: SimplifiedAccountModel.fromJson(json['owner']),
      avatar: json['avatar'],
      bio: json['bio'],
      joinStatus: joinStatus,
      membersCount: json['members_count'],
      role: role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'privacy': privacy,
      'owner': (owner as SimplifiedAccountModel).toJson(),
      'avatar': avatar,
      'bio': bio,
      'members_count': membersCount,
      'join_status': joinStatus.name,
      'role': role?.name,
    };
  }

  GroupEntity toEntity() {
    return GroupEntity(
      id: id,
      name: name,
      privacy: privacy,
      owner: owner,
      joinStatus: joinStatus,
      avatar: avatar,
      bio: bio,
      membersCount: membersCount,
      role: role,
    );
  }
}
