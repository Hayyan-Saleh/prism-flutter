import 'package:prism/features/account/data/models/account/main/personal_account_model.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
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
    required super.followingStatus,
    required super.followingCount,
    required super.isBlocked,
  });

  factory OtherAccountModel.fromJson(Map<String, dynamic> json) {
    final personalAccount = PersonalAccountModel.fromJson(json);
    final bool isBlocked = json['is_blocked'] ?? false;
    final isFollowingRaw = json['is_following'];
    final isRequestedRaw = json['is_requested'] as bool? ?? false;
    FollowStatus status;
    if (isRequestedRaw) {
      status = FollowStatus.pending;
    } else if (isFollowingRaw is bool) {
      status =
          isFollowingRaw ? FollowStatus.following : FollowStatus.notFollowing;
    } else if (isFollowingRaw == 'owner') {
      status = FollowStatus.following;
    } else {
      status = FollowStatus.notFollowing;
    }

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
      followingStatus: status,
      isBlocked: isBlocked,
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
      followingStatus: entity.followingStatus,
      followingCount: entity.followingCount,
      isBlocked: entity.isBlocked,
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

    return {...personalAccountJson, 'is_following': followingStatus.toString()};
  }
}
