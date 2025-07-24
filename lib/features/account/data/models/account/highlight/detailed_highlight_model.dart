import 'package:prism/features/account/data/models/account/highlight/highlight_status_model.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/detailed_highlight_entity.dart';

class DetailedHighlightModel extends DetailedHighlightEntity {
  const DetailedHighlightModel({
    required super.id,
    super.text,
    super.cover,
    required super.statuses,
  });

  factory DetailedHighlightModel.fromJson(Map<String, dynamic> json) {
    return DetailedHighlightModel(
      id: json['id'],
      text: json['text'],
      cover: json['cover'],
      statuses: (json['statuses'] as List)
          .map((statusJson) => HighlightStatusModel.fromJson(statusJson))
          .toList(),
    );
  }
}
