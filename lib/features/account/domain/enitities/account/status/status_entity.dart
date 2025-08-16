import 'package:equatable/equatable.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class StatusEntity extends Equatable {
  final int id;
  final String? text;
  final DateTime expirationDate;
  final String privacy;
  final MediaEntity? media;
  final DateTime createdAt;
  final SimplifiedAccountEntity user;

  const StatusEntity({
    required this.id,
    required this.text,
    required this.expirationDate,
    required this.privacy,
    this.media,
    required this.createdAt,
    required this.user,
  });

  @override
  List<Object?> get props => [
    id,
    text,
    expirationDate,
    privacy,
    media,
    createdAt,
    user,
  ];
}
