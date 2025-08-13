import 'package:flutter/material.dart';
import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessageEntity message;

  const ChatMessageWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(message.avatar)),
      title: Text(message.name),
      subtitle: Text(message.text),
    );
  }
}
