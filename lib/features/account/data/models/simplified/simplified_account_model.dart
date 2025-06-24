import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class SimplifiedAccountModel extends SimplifiedAccountEntity {
  const SimplifiedAccountModel({
    required super.id,
    required super.fullName,
    required super.accountName,
    required super.avatar,
  });

  factory SimplifiedAccountModel.fromEntity(SimplifiedAccountEntity entity) =>
      SimplifiedAccountModel(
        id: entity.id,
        fullName: entity.fullName,
        accountName: entity.accountName,
        avatar: entity.avatar,
      );

  factory SimplifiedAccountModel.fromJson(Map<String, dynamic> json) =>
      SimplifiedAccountModel(
        id: json['id'] as int,
        fullName: json['name'] as String,
        accountName: json['username'] as String,
        avatar: json['avatar'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': fullName,
    'username': accountName,
    'avatar': avatar,
  };
}
