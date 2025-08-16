import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';

class OtherAccountEntity extends PersonalAccountEntity {
  final FollowStatus followingStatus;
  final bool isBlocked;

  const OtherAccountEntity({
    required super.id,
    required super.fullName,
    required super.picUrl,
    required super.postsCount,
    required super.followersCount,
    required super.bio,
    required super.isPrivate,
    required super.hasStatus,
    required super.accountName,
    required super.personalInfos,
    required super.followingCount,
    required this.followingStatus,
    required this.isBlocked,
  });

  @override
  List<Object> get props => [...super.props, followingStatus, isBlocked];
}
