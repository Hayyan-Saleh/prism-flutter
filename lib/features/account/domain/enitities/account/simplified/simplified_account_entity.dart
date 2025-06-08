import 'package:equatable/equatable.dart';

class SimplifiedAccountEntity extends Equatable {
  final int id;
  final String name;
  final String avatar;

  const SimplifiedAccountEntity({
    required this.id,
    required this.name,
    required this.avatar,
  });

  @override
  List<Object> get props => [id, name, avatar];
}
