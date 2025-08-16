import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/domain/enitities/account/main/group_account_entity.dart';

class GroupAccountModel extends GroupAccountEntity {
  const GroupAccountModel({
    required super.id,
    required super.fullName,
    required super.picUrl,
    required super.postsCount,
    required super.followersCount,
    required super.bio,
    required super.isPrivate,
    required List<SimplifiedAccountModel> adminIds,
  }) : super(adminIds: adminIds);

  factory GroupAccountModel.fromJson(Map<String, dynamic> json) {
    return GroupAccountModel(
      id: json['id'],
      fullName: json['full_name'],
      picUrl: json['pic_url'],
      postsCount: json['posts_count'],
      followersCount: json['followers_count'],
      bio: json['bio'],
      isPrivate: json['is_private'],
      adminIds:
          (json['admin_ids'] as List)
              .map((admin) => SimplifiedAccountModel.fromJson(admin))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'pic_url': picUrl,
      'posts_count': postsCount,
      'followers_count': followersCount,
      'bio': bio,
      'is_private': isPrivate,
      'admin_ids':
          (adminIds as List<SimplifiedAccountModel>)
              .map((admin) => admin.toJson())
              .toList(),
    };
  }
}
