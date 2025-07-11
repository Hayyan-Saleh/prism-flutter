part of 'follow_bloc.dart';

abstract class FollowState extends Equatable {
  const FollowState();

  @override
  List<Object> get props => [];
}

class FollowInitial extends FollowState {}

class LoadingFollowState extends FollowState {}

class DoneFollowState extends FollowState {
  final FollowStatus newStatus;

  const DoneFollowState({required this.newStatus});

  @override
  List<Object> get props => [newStatus];
}

class FailedFollowState extends FollowState {
  final AppFailure failure;

  const FailedFollowState({required this.failure});

  @override
  List<Object> get props => [failure];
}
