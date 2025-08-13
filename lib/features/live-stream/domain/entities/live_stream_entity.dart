import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class LiveStreamEntity {
  final String id;
  final int views;
  final String streamKey;
  final String streamURL;
  final SimplifiedAccountEntity creator;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LiveStreamEntity({
    required this.id,
    required this.views,
    required this.streamKey,
    required this.streamURL,
    required this.creator,
    required this.createdAt,
    required this.updatedAt,
  });
}
