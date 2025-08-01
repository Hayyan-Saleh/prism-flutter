import 'package:prism/features/account/domain/enitities/account/main/account_role.dart';
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
    required super.role,
  });

  factory SimplifiedAccountModel.fromEntity(SimplifiedAccountEntity entity) =>
      SimplifiedAccountModel(
        id: entity.id,
        fullName: entity.fullName,
        accountName: entity.accountName,
        avatar: entity.avatar,
        followingStatus: entity.followingStatus,
        isPrivate: entity.isPrivate,
        role: entity.role,
      );

  factory SimplifiedAccountModel.fromJson(Map<String, dynamic> json) {
    final isFollowingRaw = json['is_following'] ?? 'false';
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

    AccountRole role;
    switch (json['role']) {
      case 'owner':
        role = AccountRole.owner;
        break;
      case 'admin':
        role = AccountRole.admin;
        break;
      case 'member':
      default:
        role = AccountRole.member;
    }

    return SimplifiedAccountModel(
      id: json['id'] as int,
      fullName: json['name'] as String,
      accountName: json['username'] as String,
      avatar: json['avatar'] as String? ?? '',
      followingStatus: status,
      isPrivate:
          (json['is_private'] is int?
              ? json['is_private']
              : int.parse(json['is_private'] ?? "0")) ==
          1,
      role: role,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': fullName,
    'username': accountName,
    'avatar': avatar,
    'is_following': followingStatus.toString(),
    'is_private': isPrivate,
    'role': role.name,
  };
}
