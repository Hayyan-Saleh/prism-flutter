part of 'group_bloc.dart';

sealed class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

final class GroupInitial extends GroupState {}

class GroupCreateLoading extends GroupState {}

class GroupCreateSuccess extends GroupState {
  final GroupAccountEntity group;
  const GroupCreateSuccess(this.group);
  @override
  List<Object> get props => [group];
}

class GroupCreateFailure extends GroupState {
  final String message;
  const GroupCreateFailure(this.message);
  @override
  List<Object> get props => [message];
}
