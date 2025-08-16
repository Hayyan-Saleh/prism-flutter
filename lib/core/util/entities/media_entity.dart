import 'package:equatable/equatable.dart';

enum MediaType { image, video }

class MediaEntity extends Equatable {
  final int id;
  final MediaType type;
  final String url;

  const MediaEntity({required this.id, required this.type, required this.url});

  @override
  List<Object> get props => [id, type, url];
}
