import 'package:equatable/equatable.dart';

class JoinRequestEntity extends Equatable {
  final int id;
  final int userId;
  final int groupId;
  final String name;
  final String username;
  final String? avatar;
  final DateTime requestedAt;

  const JoinRequestEntity({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.name,
    required this.username,
    this.avatar,
    required this.requestedAt,
  });

  @override
  List<Object?> get props => [id, userId, groupId, name, username, avatar, requestedAt];
}
