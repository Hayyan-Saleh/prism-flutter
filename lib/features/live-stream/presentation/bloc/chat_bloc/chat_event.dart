import 'package:equatable/equatable.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ConnectToChatEvent extends ChatEvent {
  final String streamKey;

  const ConnectToChatEvent({required this.streamKey});

  @override
  List<Object> get props => [streamKey];
}

class SendChatMessageEvent extends ChatEvent {
  final ChatMessageEntity message;
  final String streamKey;

  const SendChatMessageEvent({required this.message, required this.streamKey});

  @override
  List<Object> get props => [message, streamKey];
}

class DisconnectFromChatEvent extends ChatEvent {
  final String streamKey;

  const DisconnectFromChatEvent({required this.streamKey});

  @override
  List<Object> get props => [streamKey];
}

// Internal events

class ChatMessageReceived extends ChatEvent {
  final ChatMessageEntity message;
  const ChatMessageReceived(this.message);
  @override
  List<Object> get props => [message];
}

class ViewsReceived extends ChatEvent {
  final int views;
  const ViewsReceived(this.views);
  @override
  List<Object> get props => [views];
}

class ChatErrorOccurred extends ChatEvent {
  final String error;
  const ChatErrorOccurred(this.error);
  @override
  List<Object> get props => [error];
}

class StreamEndedEvent extends ChatEvent {
  const StreamEndedEvent();
}
