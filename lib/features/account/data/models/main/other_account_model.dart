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
    required super.personalInfos,
    required super.hasStatus,
    required super.isFollowing,
    required super.followingCount,
  });

  factory OtherAccountModel.fromJson(Map<String, dynamic> json) {
    final personalAccount = PersonalAccountModel.fromJson(json);

    return OtherAccountModel(
      id: personalAccount.id,
      fullName: personalAccount.fullName,
      picUrl: personalAccount.picUrl,
      postsCount: personalAccount.postsCount,
      followersCount: personalAccount.followersCount,
      bio: personalAccount.bio,
      isPrivate: personalAccount.isPrivate,
      personalInfos: personalAccount.personalInfos,
      accountName: personalAccount.accountName,
      followingCount: personalAccount.followingCount,
      hasStatus: personalAccount.hasStatus,
      isFollowing:
          json['is_following'] is bool
              ? json['is_following']
              : json['is_following'] == 'owner',
    );
  }

  factory OtherAccountModel.fromEntity(OtherAccountEntity entity) {
    return OtherAccountModel(
      id: entity.id,
      fullName: entity.fullName,
      accountName: entity.accountName,
      picUrl: entity.picUrl,
      postsCount: entity.postsCount,
      followersCount: entity.followersCount,
      bio: entity.bio,
      isPrivate: entity.isPrivate,
      personalInfos: entity.personalInfos,
      hasStatus: entity.hasStatus,
      isFollowing: entity.isFollowing,
      followingCount: entity.followingCount,
    );
  }

  OtherAccountEntity toEntity() => this;

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
          personalInfos: personalInfos,
          accountName: accountName,
          followingCount: followingCount,
          hasStatus: hasStatus,
        ).toJson();

    return {...personalAccountJson, 'is_following': isFollowing};
  }
}
