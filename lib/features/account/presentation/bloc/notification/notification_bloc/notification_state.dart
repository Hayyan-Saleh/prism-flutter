part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<FollowRequestEntity> followRequests;

  const NotificationLoaded({required this.followRequests});

  @override
  List<Object> get props => [followRequests];
}

class JoinRequestsLoaded extends NotificationState {
  final List<JoinRequestEntity> joinRequests;

  const JoinRequestsLoaded({required this.joinRequests});

  @override
  List<Object> get props => [joinRequests];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object> get props => [message];
}

class FollowRequestResponseSuccess extends NotificationState {}

class JoinRequestResponseSuccess extends NotificationState {}
