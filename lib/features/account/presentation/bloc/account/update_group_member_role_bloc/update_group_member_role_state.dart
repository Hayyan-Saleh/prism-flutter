part of 'update_group_member_role_bloc.dart';

abstract class UpdateGroupMemberRoleState extends Equatable {
  const UpdateGroupMemberRoleState();

  @override
  List<Object> get props => [];
}

class UpdateGroupMemberRoleInitial extends UpdateGroupMemberRoleState {}

class UpdateGroupMemberRoleLoading extends UpdateGroupMemberRoleState {}

class UpdateGroupMemberRoleSuccess extends UpdateGroupMemberRoleState {}

class UpdateGroupMemberRoleFailure extends UpdateGroupMemberRoleState {
  final AccountFailure failure;

  const UpdateGroupMemberRoleFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
