import 'package:prism/core/util/models/pagination_model.dart';
import 'package:prism/features/live-stream/data/models/live_stream_model.dart';
import 'package:prism/features/live-stream/domain/entities/paginated_live_streams_entity.dart';

class PaginatedLiveStreamsModel extends PaginatedLiveStreamsEntity {
  const PaginatedLiveStreamsModel({
    required super.streams,
    required super.pagination,
  });

  factory PaginatedLiveStreamsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedLiveStreamsModel(
      streams: (json['streams'] as List)
          .map((stream) => LiveStreamModel.fromJson(stream))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'streams': streams.map((stream) => (stream as LiveStreamModel).toJson()).toList(),
      'pagination': (pagination as PaginationModel).toJson(),
    };
  }
}
