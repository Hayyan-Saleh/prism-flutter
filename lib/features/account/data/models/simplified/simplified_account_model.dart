import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class SimplifiedAccountModel extends SimplifiedAccountEntity {
  const SimplifiedAccountModel({
    required super.id,
    required super.name,
    required super.avatar,
  });

  factory SimplifiedAccountModel.fromJson(Map<String, dynamic> json) =>
      SimplifiedAccountModel(
        id: json['id'],
        name: json['name'],
        avatar: json['avatar'],
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'avatar': avatar};
}
