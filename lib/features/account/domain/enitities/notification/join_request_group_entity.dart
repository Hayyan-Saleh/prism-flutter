import 'package:equatable/equatable.dart';

class JoinRequestGroupEntity extends Equatable {
  final int id;
  final String name;
  final String privacy;
  final String? bio;
  final String? avatar;

  const JoinRequestGroupEntity({
    required this.id,
    required this.name,
    required this.privacy,
    this.bio,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, name, privacy, bio, avatar];
}
