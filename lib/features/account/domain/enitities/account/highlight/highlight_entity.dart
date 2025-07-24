import 'package:equatable/equatable.dart';

class HighlightEntity extends Equatable {
  final int id;
  final String? text;
  final String? cover;
  final int statusesCount;
  final String? textAsCover;

  const HighlightEntity({
    required this.id,
    this.text,
    this.cover,
    required this.statusesCount,
    this.textAsCover,
  });

  @override
  List<Object?> get props => [id, text, cover, statusesCount, textAsCover];
}

