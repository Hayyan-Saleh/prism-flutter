import 'package:prism/features/account/domain/enitities/account/highlight/highlight_entity.dart';

class HighlightModel extends HighlightEntity {
  const HighlightModel({
    required super.id,
    super.text,
    super.cover,
    required super.statusesCount,
    super.textAsCover,
  });

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    return HighlightModel(
      id: json['id'],
      text: json['text'],
      cover: json['cover'],
      statusesCount: json['statuses_count'],
      textAsCover: json['text_as_cover'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'cover': cover,
      'statuses_count': statusesCount,
      'text_as_cover': textAsCover,
    };
  }
}
