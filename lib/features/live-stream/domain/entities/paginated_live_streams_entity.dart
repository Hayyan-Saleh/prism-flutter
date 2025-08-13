import 'package:equatable/equatable.dart';
import 'package:prism/core/util/entities/pagination_entity.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';

class PaginatedLiveStreamsEntity extends Equatable {
  final List<LiveStreamEntity> streams;
  final PaginationEntity pagination;

  const PaginatedLiveStreamsEntity({
    required this.streams,
    required this.pagination,
  });

  @override
  List<Object?> get props => [streams, pagination];
}
