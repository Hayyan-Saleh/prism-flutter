import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';

class SimplifiedAccountEntity extends Equatable {
  final int id;
  final String fullName;
  final String accountName;
  final String avatar;
  final FollowStatus followingStatus;
  final bool isPrivate;

  const SimplifiedAccountEntity({
    required this.id,
    required this.fullName,
    required this.accountName,
    required this.avatar,
    required this.followingStatus,
    required this.isPrivate,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    accountName,
    avatar,
    followingStatus,
    isPrivate,
  ];
}
