part of 'update_group_member_role_bloc.dart';

abstract class UpdateGroupMemberRoleEvent extends Equatable {
  const UpdateGroupMemberRoleEvent();

  @override
  List<Object> get props => [];
}

class UpdateRole extends UpdateGroupMemberRoleEvent {
  final int groupId;
  final int userId;
  final AccountRole role;

  const UpdateRole({
    required this.groupId,
    required this.userId,
    required this.role,
  });

  @override
  List<Object> get props => [groupId, userId, role];
}
