import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/data/models/account/simplified/simplified_group_model.dart';
import 'package:prism/features/account/domain/enitities/notification/join_request_entity.dart';

class JoinRequestModel extends JoinRequestEntity {
  const JoinRequestModel({
    required super.id,
    required super.requestedAt,
    required super.creator,
    required super.group,
  });

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) {
    return JoinRequestModel(
      id: json['id'],
      requestedAt: DateTime.parse(json['requested_at']),
      creator: SimplifiedAccountModel.fromJson(json['creator']),
      group:
          json['group'] != null
              ? SimplifiedGroupModel.fromJson(json['group'])
              : null,
    );
  }
}
