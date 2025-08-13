import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String name;
  final String avatar;
  final String text;

  const ChatMessageEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.text,
  });

  @override
  List<Object?> get props => [id, name, avatar, text];
}
