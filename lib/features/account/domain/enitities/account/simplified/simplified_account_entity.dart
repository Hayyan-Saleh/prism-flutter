import 'package:equatable/equatable.dart';

class SimplifiedAccountEntity extends Equatable {
  final int id;
  final String fullName;
  final String accountName;
  final String? avatar;

  const SimplifiedAccountEntity({
    required this.id,
    required this.fullName,
    required this.accountName,
    required this.avatar,
  });

  @override
  List<Object> get props =>
      avatar != null
          ? [id, fullName, accountName]
          : [id, fullName, accountName, avatar!];
}
