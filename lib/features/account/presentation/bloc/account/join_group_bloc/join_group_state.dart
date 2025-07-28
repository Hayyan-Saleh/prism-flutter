part of 'join_group_bloc.dart';

sealed class JoinGroupState extends Equatable {
  const JoinGroupState();
  
  @override
  List<Object> get props => [];
}

final class JoinGroupInitial extends JoinGroupState {}

final class JoinGroupLoading extends JoinGroupState {}

final class JoinGroupSuccess extends JoinGroupState {
  final JoinStatus newStatus;

  const JoinGroupSuccess({required this.newStatus});

  @override
  List<Object> get props => [newStatus];
}

final class JoinGroupFailure extends JoinGroupState {
  final AppFailure failure;

  const JoinGroupFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}