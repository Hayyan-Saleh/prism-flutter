import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/main/other_account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/paginated_simplified_account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';
import 'package:prism/features/account/domain/enitities/account/group/group_account_entity.dart';

import '../enitities/account/highlight/detailed_highlight_entity.dart';
import '../enitities/account/highlight/highlight_entity.dart';

abstract class AccountRepository {
  // ! all following implementations should be wrapped with token for auth (ask hayyan for that)

  //? phase 1 methods:
  Future<Either<AccountFailure, bool>> checkAccountName({
    required String accountName,
  });

  ///
  /// the following method needs to:
  /// 1- edit the personal account
  /// 2- save it locally
  ///
  Future<Either<AccountFailure, PersonalAccountEntity>> updatePersonalAccount({
    required File? profilePic,
    required PersonalAccountEntity personalAccount,
  });

  Future<Either<AppFailure, PersonalAccountEntity?>> getLocalPersonalAccount();

  ///
  /// the following method needs to:
  /// 1- get the personal account
  /// 2- store personal account
  ///
  Future<Either<AppFailure, PersonalAccountEntity>> getRemotePersonalAccount();

  Future<Either<AccountFailure, OtherAccountEntity>> getOtherAccount({
    required int id,
  });

  Future<Either<AppFailure, FollowStatus>> updateFollowingStatus({
    required int targetId,
    required bool newStatus,
  });

  Future<Either<AccountFailure, Unit>> deleteAccount();

  Future<Either<AccountFailure, List<StatusEntity>>> getStatuses({
    required int accountId,
  });
  Future<Either<AccountFailure, Unit>> createStatus({
    required String privacy,
    String? text,
    File? media,
  });

  Future<Either<AccountFailure, List<SimplifiedAccountModel>>>
  getFollowingStatuses();

  Future<Either<AccountFailure, Unit>> deleteStatus({required int statusId});

  Future<Either<AccountFailure, List<SimplifiedAccountModel>>> getFollowers({
    required int accountId,
  });
  Future<Either<AccountFailure, List<SimplifiedAccountModel>>> getFollowing({
    required int accountId,
  });
  //? phase 2 methods:

  Future<Either<AccountFailure, PaginatedSimplifiedAccountEntity>>
  searchAccounts({required String query, required int pageNum});

  Future<Either<AccountFailure, Unit>> blockUser({required int targetId});

  Future<Either<AccountFailure, Unit>> unblockUser({required int targetId});

  Future<Either<AccountFailure, List<SimplifiedAccountModel>>>
  getBlockedAccounts();

  Future<Either<AccountFailure, List<StatusEntity>>> getArchivedStatuses();

  Future<Either<AccountFailure, Unit>> createHighlight({
    required List<int> statusIds,
    String? text,
    File? cover,
  });

  Future<Either<AccountFailure, Unit>> toggleLikeStatus({
    required int statusId,
  });

  Future<Either<AccountFailure, List<SimplifiedAccountModel>>> getStatusLikers({
    required int statusId,
  });

  Future<Either<AccountFailure, List<HighlightEntity>>> getHighlights({
    int? accountId,
  });

  Future<Either<AccountFailure, DetailedHighlightEntity>> getDetailedHighlight({
    required int highlightId,
  });

  Future<Either<AccountFailure, Unit>> deleteHighlight({
    required int highlightId,
  });

  Future<Either<AccountFailure, Unit>> updateHighlightCover({
    required int highlightId,
    required File cover,
  });

  Future<Either<AccountFailure, Unit>> addToHighlight({
    required int highlightId,
    required int statusId,
  });

  Future<Either<AccountFailure, GroupAccountEntity>> createGroup({
    required String name,
    required String privacy,
    File? avatar,
    String? bio,
  });
}
