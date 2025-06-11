import 'package:prism/core/util/entities/media_entity.dart';

class MediaModel extends MediaEntity {
  const MediaModel({
    required super.id,
    required super.type,
    required super.url,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      MediaModel(id: json['id'], type: json['type'], url: json['url']);

  Map<String, dynamic> toJson() => {'id': id, 'type': type, 'url': url};
}
