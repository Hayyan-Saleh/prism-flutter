part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class GroupCreateLoading extends GroupState {}

class GroupCreateSuccess extends GroupState {
  final GroupEntity group;

  const GroupCreateSuccess(this.group);
}

class GroupCreateFailure extends GroupState {
  final String message;

  const GroupCreateFailure(this.message);
}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final GroupEntity group;

  const GroupLoaded(this.group);
}

class GroupFailure extends GroupState {
  final String message;

  const GroupFailure(this.message);
}

class GroupUpdateSuccess extends GroupState {}

class GroupUpdateFailure extends GroupState {
  final String message;

  const GroupUpdateFailure(this.message);
}

class GroupDeleteInProgress extends GroupState {}

class GroupDeleteSuccess extends GroupState {}

class GroupDeleteFailure extends GroupState {
  final String message;

  const GroupDeleteFailure(this.message);

  @override
  List<Object> get props => [message];
}
