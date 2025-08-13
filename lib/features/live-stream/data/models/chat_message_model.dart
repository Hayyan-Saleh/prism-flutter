import 'package:prism/features/live-stream/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.name,
    required super.avatar,
    required super.text,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'text': text,
    };
  }
}
