import 'package:prism/features/account/domain/enitities/account/main/account_entity.dart';

class PersonalAccountEntity extends AccountEntity {
  final List<String> personalInfoKeys;
  final List<String> personalInfoValues;
  final String hasStatus;

  const PersonalAccountEntity({
    required super.id,
    required super.fullName,
    required super.accountName,
    required super.picUrl,
    required super.postsCount,
    required super.followersCount,
    required super.bio,
    required super.isPrivate,
    required this.personalInfoKeys,
    required this.personalInfoValues,
    required this.hasStatus,
  });

  @override
  List<Object> get props => [
    ...super.props,
    hasStatus,
    personalInfoKeys,
    personalInfoValues,
  ];
}
