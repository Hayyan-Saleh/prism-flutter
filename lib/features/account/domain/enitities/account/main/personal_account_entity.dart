import 'package:prism/features/account/domain/enitities/account/main/account_entity.dart';

class PersonalAccountEntity extends AccountEntity {
  final Map<String, List<String>> personalInfos;
  final String accountName;
  final int followingCount;
  final bool hasStatus;

  const PersonalAccountEntity({
    required super.id,
    required super.fullName,
    required super.picUrl,
    required super.postsCount,
    required super.followersCount,
    required super.bio,
    required super.isPrivate,
    required this.hasStatus,
    required this.accountName,
    required this.personalInfos,
    required this.followingCount,
  });

  static PersonalAccountEntity fromScratch({
    required String fullName,
    required String bio,
    required bool isPrivate,
    required Map<String, List<String>> personalInfos,
    required String accountName,
  }) {
    return PersonalAccountEntity(
      id: 0,
      fullName: fullName,
      picUrl: null,
      postsCount: 0,
      followersCount: 0,
      bio: bio,
      isPrivate: isPrivate,
      personalInfos: personalInfos,
      hasStatus: false,
      accountName: accountName,
      followingCount: 0,
    );
  }

  @override
  List<Object> get props => [
    ...super.props,
    hasStatus,
    personalInfos,
    accountName,
    followingCount,
  ];
}
