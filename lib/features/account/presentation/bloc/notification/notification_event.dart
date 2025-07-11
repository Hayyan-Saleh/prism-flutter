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
