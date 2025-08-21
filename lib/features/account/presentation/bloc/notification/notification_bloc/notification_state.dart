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
  final List<JoinRequestEntity> joinRequests;

  const NotificationLoaded({
    this.followRequests = const [],
    this.joinRequests = const [],
  });

  NotificationLoaded copyWith({
    List<FollowRequestEntity>? followRequests,
    List<JoinRequestEntity>? joinRequests,
  }) {
    return NotificationLoaded(
      followRequests: followRequests ?? this.followRequests,
      joinRequests: joinRequests ?? this.joinRequests,
    );
  }

  @override
  List<Object> get props => [followRequests, joinRequests];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object> get props => [message];
}

class FollowRequestResponseSuccess extends NotificationState {}

class JoinRequestResponseSuccess extends NotificationState {}