import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/domain/enitities/account/group/group_account_entity.dart';

class GroupAccountModel extends GroupAccountEntity {
  const GroupAccountModel({
    required super.id,
    required super.name,
    required super.privacy,
    required SimplifiedAccountModel super.owner,
    super.avatar,
    super.bio,
  });

  factory GroupAccountModel.fromJson(Map<String, dynamic> json) {
    return GroupAccountModel(
      id: json['id'],
      name: json['name'],
      privacy: json['privacy'],
      owner: SimplifiedAccountModel.fromJson(json['owner']),
      avatar: json['avatar'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'privacy': privacy,
      'owner': (owner as SimplifiedAccountModel).toJson(),
      'avatar': avatar,
      'bio': bio,
    };
  }

  GroupAccountEntity toEntity() {
    return GroupAccountEntity(
      id: id,
      name: name,
      privacy: privacy,
      owner: owner,
      avatar: avatar,
      bio: bio,
    );
  }
}
