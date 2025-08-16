import 'package:prism/features/account/domain/enitities/account/main/account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';

class GroupAccountEntity extends AccountEntity {
  final List<SimplifiedAccountEntity> adminIds;

  const GroupAccountEntity({
    required super.id,
    required super.fullName,
    required super.picUrl,
    required super.postsCount,
    required super.followersCount,
    required super.bio,
    required super.isPrivate,
    required this.adminIds,
  });

  @override
  List<Object> get props => [...super.props, adminIds];
}
