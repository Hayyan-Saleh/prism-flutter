import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class SimplifiedAccountModel extends SimplifiedAccountEntity {
  const SimplifiedAccountModel({
    required super.id,
    required super.fullName,
    required super.accountName,
    required super.avatar,
    required super.followingStatus,
    required super.isPrivate,
  });

  factory SimplifiedAccountModel.fromEntity(SimplifiedAccountEntity entity) =>
      SimplifiedAccountModel(
        id: entity.id,
        fullName: entity.fullName,
        accountName: entity.accountName,
        avatar: entity.avatar,
        followingStatus: entity.followingStatus,
        isPrivate: entity.isPrivate,
      );

  factory SimplifiedAccountModel.fromJson(Map<String, dynamic> json) {
    final fullName =
        (json['name'] as String?) ?? (json['full_name'] as String?) ?? '';
    final username =
        (json['username'] as String?) ??
        fullName.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');

    final avatar = json['avatar'] as String? ?? '';

    final isPrivateRaw = json['is_private'];
    final isPrivate =
        isPrivateRaw is int
            ? isPrivateRaw == 1
            : (isPrivateRaw is bool ? isPrivateRaw : false);

    final isRequested = json['is_requested'] as bool? ?? false;
    final isFollowingRaw = json['is_following'];
    FollowStatus status;
    if (isRequested) {
      status = FollowStatus.pending;
    } else if (isFollowingRaw == 'owner' || isFollowingRaw == true) {
      status = FollowStatus.following;
    } else {
      status = FollowStatus.notFollowing;
    }
    return SimplifiedAccountModel(
      id: json['id'] as int,
      fullName: fullName,
      accountName: username,
      avatar: avatar,
      followingStatus: status,
      isPrivate: isPrivate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': fullName,
    'username': accountName,
    'avatar': avatar,
    'is_following': followingStatus.toString(),
    'is_private': isPrivate,
  };
}
