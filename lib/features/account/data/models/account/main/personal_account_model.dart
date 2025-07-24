import 'dart:convert';

import 'package:prism/features/account/data/models/account/main/account_model.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';

class PersonalAccountModel extends PersonalAccountEntity {
  const PersonalAccountModel({
    required super.id,
    required super.fullName,
    required super.picUrl,
    required super.postsCount,
    required super.followersCount,
    required super.bio,
    required super.isPrivate,
    required super.personalInfos,
    required super.accountName,
    required super.followingCount,
    required super.hasStatus,
  });

  factory PersonalAccountModel.fromJson(Map<String, dynamic> json) {
    final accountModel = AccountModel.fromJson(json);
    final personalInfo = <String, List<String>>{};
    if (json['personal_info'] != null) {
      if (json['personal_info'] is Map) {
        (json['personal_info'] as Map).forEach((key, value) {
          if (key is String && value is List) {
            personalInfo[key] =
                value
                    .where((item) => item != null)
                    .map((item) => item.toString())
                    .toList();
          }
        });
      } else {
        final Map<String, dynamic> decodedInfos = jsonDecode(
          json['personal_info'],
        );
        (decodedInfos as Map).forEach((key, value) {
          if (key is String && value is List) {
            personalInfo[key] =
                value
                    .where((item) => item != null)
                    .map((item) => item.toString())
                    .toList();
          }
        });
      }
    }

    return PersonalAccountModel(
      id: accountModel.id,
      fullName: accountModel.fullName,
      picUrl: accountModel.picUrl ?? '',
      postsCount: accountModel.postsCount,
      followersCount: accountModel.followersCount,
      bio: accountModel.bio,
      isPrivate: accountModel.isPrivate,
      personalInfos: personalInfo,
      accountName: json['username'] ?? '',
      followingCount: json['following_count'] ?? 0,
      hasStatus: json['has_status'] ?? false,
    );
  }

  factory PersonalAccountModel.fromEntity(PersonalAccountEntity entity) {
    return PersonalAccountModel(
      id: entity.id,
      fullName: entity.fullName,
      picUrl: entity.picUrl,
      postsCount: entity.postsCount,
      followersCount: entity.followersCount,
      bio: entity.bio,
      isPrivate: entity.isPrivate,
      personalInfos: entity.personalInfos,
      accountName: entity.accountName,
      followingCount: entity.followingCount,
      hasStatus: entity.hasStatus,
    );
  }

  PersonalAccountEntity toEntity() => this;

  Map<String, dynamic> toJson() {
    final baseJson =
        AccountModel(
          id: id,
          fullName: fullName,
          picUrl: picUrl,
          postsCount: postsCount,
          followersCount: followersCount,
          bio: bio,
          isPrivate: isPrivate,
        ).toJson();

    return {
      ...baseJson,
      'username': accountName,
      'following_count': followingCount,
      'has_status': hasStatus,
      'personal_info': personalInfos,
    };
  }
}
