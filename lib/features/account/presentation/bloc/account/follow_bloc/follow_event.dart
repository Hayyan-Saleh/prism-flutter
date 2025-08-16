part of 'follow_bloc.dart';

sealed class FollowEvent extends Equatable {
  const FollowEvent();

  @override
  List<Object> get props => [];
}

class ToggleFollowEvent extends FollowEvent {
  final int targetId;
  final bool newStatus;

  const ToggleFollowEvent({required this.targetId, required this.newStatus});

  @override
  List<Object> get props => [targetId, newStatus];
}
