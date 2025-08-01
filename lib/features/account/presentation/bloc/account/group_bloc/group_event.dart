part of 'group_bloc.dart';

sealed class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class CreateGroupEvent extends GroupEvent {
  final String name;
  final String privacy;
  final File? avatar;
  final String? bio;

  const CreateGroupEvent({
    required this.name,
    required this.privacy,
    this.avatar,
    this.bio,
  });
}

class GetGroupEvent extends GroupEvent {
  final int groupId;

  const GetGroupEvent({required this.groupId});
}

class UpdateGroupEvent extends GroupEvent {
  final int groupId;
  final String? name;
  final String? privacy;
  final File? avatar;
  final String? bio;

  const UpdateGroupEvent({
    required this.groupId,
    this.name,
    this.privacy,
    this.avatar,
    this.bio,
  });
}

class DeleteGroup extends GroupEvent {
  final int groupId;

  const DeleteGroup({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class GetGroupJoinRequestsEvent extends GroupEvent {
  final int groupId;

  const GetGroupJoinRequestsEvent({required this.groupId});

  @override
  List<Object> get props => [groupId];
}
