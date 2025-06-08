import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String id;
  final String fullName;
  final String accountName;
  final String picUrl;
  final int postsCount;
  final int followersCount;
  final String bio;
  final bool isPrivate;

  const AccountEntity({
    required this.id,
    required this.fullName,
    required this.accountName,
    required this.picUrl,
    required this.postsCount,
    required this.followersCount,
    required this.bio,
    required this.isPrivate,
  });

  @override
  List<Object> get props => [
    id,
    fullName,
    accountName,
    picUrl,
    postsCount,
    followersCount,
    bio,
    isPrivate,
  ];
}
