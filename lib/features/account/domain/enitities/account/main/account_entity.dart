import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final int id;
  final String fullName;
  final String? picUrl;
  final int postsCount;
  final int followersCount;
  final String bio;
  final bool isPrivate;

  const AccountEntity({
    required this.id,
    required this.fullName,
    required this.picUrl,
    required this.postsCount,
    required this.followersCount,
    required this.bio,
    required this.isPrivate,
  });

  @override
  List<Object> get props =>
      picUrl == null
          ? [id, fullName, postsCount, followersCount, bio, isPrivate]
          : [id, fullName, picUrl!, postsCount, followersCount, bio, isPrivate];
}
