part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetFollowRequestsEvent extends NotificationEvent {}

class RespondToFollowRequestEvent extends NotificationEvent {
  final int requestId;
  final String response;

  const RespondToFollowRequestEvent({
    required this.requestId,
    required this.response,
  });

  @override
  List<Object> get props => [requestId, response];
}

class GetJoinRequestsEvent extends NotificationEvent {}

class RespondToJoinRequestEvent extends NotificationEvent {
  final int groupId;
  final int requestId;
  final String response;
  final bool fromGroup;

  const RespondToJoinRequestEvent({
    required this.groupId,
    required this.requestId,
    required this.response,
    required this.fromGroup,
  });

  @override
  List<Object> get props => [groupId, requestId, response, fromGroup];
}
