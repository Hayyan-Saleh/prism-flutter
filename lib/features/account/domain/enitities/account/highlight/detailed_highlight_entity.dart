import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/highlight_status_entity.dart';

class DetailedHighlightEntity extends Equatable {
  final int id;
  final String? text;
  final String? cover;
  final List<HighlightStatusEntity> statuses;

  const DetailedHighlightEntity({
    required this.id,
    this.text,
    this.cover,
    required this.statuses,
  });

  @override
  List<Object?> get props => [id, text, cover, statuses];
}
