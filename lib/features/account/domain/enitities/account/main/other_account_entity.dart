import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';

class OtherAccountEntity extends PersonalAccountEntity {
  final bool isFollowing;

  const OtherAccountEntity({
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
    required this.isFollowing,
    required super.followingCount,
  });

  @override
  List<Object> get props => [...super.props, isFollowing];
}
