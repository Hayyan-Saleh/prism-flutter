import 'package:prism/features/account/domain/enitities/account/main/account_entity.dart';

class AccountModel extends AccountEntity {
  const AccountModel({
    required super.id,
    required super.fullName,
    required super.picUrl,
    required super.postsCount,
    required super.followersCount,
    required super.bio,
    required super.isPrivate,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    id: json['id'],
    fullName: json['name'],
    picUrl: json['avatar'],
    postsCount: json['posts_count'] ?? 0,
    followersCount: json['followers_count'] ?? 0,
    bio: json['bio'] ?? '',
    isPrivate:
        (json['is_private'] is int
            ? json['is_private']
            : int.parse(json['is_private'])) ==
        1,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': fullName,
    'avatar': picUrl,
    'posts_count': postsCount,
    'followers_count': followersCount,
    'bio': bio,
    'is_private': isPrivate ? 1 : 0, // Convert bool back to 0/1
  };
}
