import 'package:prism/features/account/domain/enitities/account/highlight/highlight_status_entity.dart';

class HighlightStatusModel extends HighlightStatusEntity {
  const HighlightStatusModel({
    required super.id,
    super.text,
    required super.expirationDate,
    super.media,
    super.type,
    required super.addedAt,
  });

  factory HighlightStatusModel.fromJson(Map<String, dynamic> json) {
    return HighlightStatusModel(
      id: json['id'],
      text: json['text'],
      expirationDate: DateTime.parse(json['expiration_date']),
      media: json['media'],
      type: json['type'],
      addedAt: DateTime.parse(json['added_at']),
    );
  }
}
