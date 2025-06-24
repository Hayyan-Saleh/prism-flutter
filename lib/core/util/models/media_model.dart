import 'package:prism/core/util/entities/media_entity.dart';

class MediaModel extends MediaEntity {
  const MediaModel({
    required super.id,
    required super.type,
    required super.url,
  });

  factory MediaModel.fromEntity(MediaEntity entity) =>
      MediaModel(id: entity.id, type: entity.type, url: entity.url);

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
    id: json['id'] as int,
    type: MediaType.values.firstWhere((e) => e.name == json['type']),
    url: json['url'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'type': type.name, 'url': url};
}
