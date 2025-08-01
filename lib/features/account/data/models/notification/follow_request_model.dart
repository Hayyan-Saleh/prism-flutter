import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/domain/enitities/notification/follow_request_entity.dart';

class FollowRequestModel extends FollowRequestEntity {
  const FollowRequestModel({required super.id, required super.creator});

  factory FollowRequestModel.fromJson(Map<String, dynamic> json) {
    return FollowRequestModel(
      id: json['id'],
      creator: SimplifiedAccountModel.fromJson(json['creator']),
    );
  }
}
