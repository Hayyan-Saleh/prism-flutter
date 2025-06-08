import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class CommentEntity extends Equatable {
  final int id;
  final String text;
  final int likesCount;
  final SimplifiedAccountEntity user;
  final DateTime createdAt;

  const CommentEntity({
    required this.id,
    required this.text,
    required this.likesCount,
    required this.user,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, text, likesCount, user, createdAt];
}
