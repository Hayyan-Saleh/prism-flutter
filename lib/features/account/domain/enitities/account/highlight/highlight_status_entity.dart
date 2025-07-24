import 'package:equatable/equatable.dart';

class HighlightStatusEntity extends Equatable {
  final int id;
  final String? text;
  final DateTime expirationDate;
  final String? media;
  final String? type;
  final DateTime addedAt;

  const HighlightStatusEntity({
    required this.id,
    this.text,
    required this.expirationDate,
    this.media,
    this.type,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [id, text, expirationDate, media, type, addedAt];
}
