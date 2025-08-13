import 'package:equatable/equatable.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatConnecting extends ChatState {
  const ChatConnecting();
}

class ChatConnected extends ChatState {
  final List<ChatMessageEntity> messages;
  final int views;
  const ChatConnected({required this.messages, required this.views});

  @override
  List<Object?> get props => [messages, views];
}

class ChatError extends ChatState {
  final String error;
  const ChatError({required this.error});

  @override
  List<Object?> get props => [error];
}

class ChatDisconnected extends ChatState {
  const ChatDisconnected();
}