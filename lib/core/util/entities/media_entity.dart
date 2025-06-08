import 'package:equatable/equatable.dart';

class MediaEntity extends Equatable {
  final int id;
  final String type;
  final String url;

  const MediaEntity({required this.id, required this.type, required this.url});

  @override
  List<Object> get props => [id, type, url];
}
