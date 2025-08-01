import 'package:equatable/equatable.dart';

class JoinRequestCreatorEntity extends Equatable {
  final int userId;
  final String name;
  final String username;
  final String? avatar;

  const JoinRequestCreatorEntity({
    required this.userId,
    required this.name,
    required this.username,
    this.avatar,
  });

  @override
  List<Object?> get props => [userId, name, username, avatar];
}
