import 'package:prism/features/account/data/models/main/personal_account_model.dart';
import 'package:prism/features/account/domain/enitities/account/main/other_account_entity.dart';

class OtherAccountModel extends OtherAccountEntity {
  const OtherAccountModel({
    required super.id,
    required super.fullName,
    required super.accountName,
    required super.picUrl,
    required super.postsCount,
    required super.followersCount,
    required super.bio,
    required super.isPrivate,
    required super.personalInfoKeys,
    required super.personalInfoValues,
    required super.hasStatus,
    required super.isFollowing,
    required super.followingCount,
  });

  factory OtherAccountModel.fromJson(Map<String, dynamic> json) {
    // Reuse PersonalAccountModel's parsing for inherited fields
    final personalAccount = PersonalAccountModel.fromJson(json);

    return OtherAccountModel(
      // Fields from AccountEntity
      id: personalAccount.id,
      fullName: personalAccount.fullName,
      picUrl: personalAccount.picUrl,
      postsCount: personalAccount.postsCount,
      followersCount: personalAccount.followersCount,
      bio: personalAccount.bio,
      isPrivate: personalAccount.isPrivate,
      // Fields from PersonalAccountEntity
      personalInfoKeys: personalAccount.personalInfoKeys,
      personalInfoValues: personalAccount.personalInfoValues,
      accountName: personalAccount.accountName,
      followingCount: personalAccount.followingCount,
      hasStatus: personalAccount.hasStatus,
      // OtherAccountEntity-specific field
      isFollowing: (json['is_following'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final personalAccountJson =
        PersonalAccountModel(
          id: id,
          fullName: fullName,
          picUrl: picUrl,
          postsCount: postsCount,
          followersCount: followersCount,
          bio: bio,
          isPrivate: isPrivate,
          personalInfoKeys: personalInfoKeys,
          personalInfoValues: personalInfoValues,
          accountName: accountName,
          followingCount: followingCount,
          hasStatus: hasStatus,
        ).toJson();

    return {
      ...personalAccountJson, // Spread inherited fields
      'is_following': isFollowing, // Add unique field
    };
  }
}
