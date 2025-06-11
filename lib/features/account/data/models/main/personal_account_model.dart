import 'package:prism/features/account/data/models/main/account_model.dart';
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
    required super.personalInfoKeys,
    required super.personalInfoValues,
    required super.accountName,
    required super.followingCount,
    required super.hasStatus,
  });

  factory PersonalAccountModel.fromJson(Map<String, dynamic> json) {
    // Reuse AccountModel's parsing for base fields
    final accountModel = AccountModel.fromJson(json);
    final personalInfo = json['personal_info'] as Map<String, dynamic>? ?? {};

    return PersonalAccountModel(
      // Inherited from AccountEntity via AccountModel
      id: accountModel.id,
      fullName: accountModel.fullName,
      picUrl: accountModel.picUrl,
      postsCount: accountModel.postsCount,
      followersCount: accountModel.followersCount,
      bio: accountModel.bio,
      isPrivate: accountModel.isPrivate,
      // PersonalAccountEntity-specific fields
      personalInfoKeys: personalInfo.keys.toList(),
      personalInfoValues:
          personalInfo.values
              .map((v) => v is List ? v.join(', ') : v.toString())
              .toList(),
      accountName: json['username'] ?? '',
      followingCount: json['following_count'] ?? 0,
      hasStatus: json['has_status'] ?? '',
    );
  }

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
      ...baseJson, // Spread base fields
      'username': accountName,
      'following_count': followingCount,
      'has_status': hasStatus,
      'personal_info': _buildPersonalInfoJson(),
    };
  }

  Map<String, dynamic> _buildPersonalInfoJson() {
    final Map<String, dynamic> result = {};
    for (int i = 0; i < personalInfoKeys.length; i++) {
      result[personalInfoKeys[i]] = personalInfoValues[i].split(', ');
    }
    return result;
  }
}
