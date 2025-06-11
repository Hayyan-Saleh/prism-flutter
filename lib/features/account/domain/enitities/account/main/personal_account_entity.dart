import 'package:prism/features/account/domain/enitities/account/main/account_entity.dart';

class PersonalAccountEntity extends AccountEntity {
  final List<String> personalInfoKeys;
  final List<String> personalInfoValues;
  final String accountName;
  final int followingCount;
  final String hasStatus;

  const PersonalAccountEntity({
    required super.id,
    required super.fullName,
    required super.picUrl,
    required super.postsCount,
    required super.followersCount,
    required super.bio,
    required super.isPrivate,
    required this.personalInfoKeys,
    required this.personalInfoValues,
    required this.hasStatus,
    required this.accountName,
    required this.followingCount,
  });

  @override
  List<Object> get props => [
    ...super.props,
    hasStatus,
    personalInfoKeys,
    personalInfoValues,
    accountName,
    followingCount,
  ];
}
