import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';

class LiveStreamModel extends LiveStreamEntity {
  const LiveStreamModel({
    required super.id,
    required super.views,
    required super.streamKey,
    required super.streamURL,
    required super.creator,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      id: json['id'],
      views: json['views'],
      streamKey: json['streamKey'],
      streamURL: json['streamURL'],
      creator: SimplifiedAccountModel.fromJson(json['creator']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'views': views,
      'streamKey': streamKey,
      'streamURL': streamURL,
      'creator': (creator as SimplifiedAccountModel).toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
