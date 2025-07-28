part of 'join_group_bloc.dart';

sealed class JoinGroupEvent extends Equatable {
  const JoinGroupEvent();

  @override
  List<Object> get props => [];
}

class ToggleJoinGroupEvent extends JoinGroupEvent {
  final int groupId;
  final bool join;

  const ToggleJoinGroupEvent({required this.groupId, required this.join});

  @override
  List<Object> get props => [groupId, join];
}