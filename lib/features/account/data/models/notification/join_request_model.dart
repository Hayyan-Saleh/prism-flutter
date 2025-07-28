import 'package:prism/features/account/domain/enitities/notification/join_request_entity.dart';

class JoinRequestModel extends JoinRequestEntity {
  const JoinRequestModel({
    required super.id,
    required super.userId,
    required super.groupId,
    required super.name,
    required super.username,
    super.avatar,
    required super.requestedAt,
  });

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) {
    return JoinRequestModel(
      id: json['id'],
      userId: json['user_id'],
      groupId: json['group_id'],
      name: json['name'],
      username: json['username'],
      avatar: json['avatar'],
      requestedAt: DateTime.parse(json['requested_at']),
    );
  }
}
