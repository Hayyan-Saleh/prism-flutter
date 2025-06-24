import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/other_account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/paginated_simplified_account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';

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
  Future<Either<AccountFailure, Unit>> updatePersonalAccount({
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
    required String id,
  });

  ///
  /// the following method needs to:
  /// 1- update the following status
  /// 2- get personal account and then return it
  ///
  Future<Either<AccountFailure, OtherAccountEntity>> updateFollowingStatus({
    required int targetId,
    required bool newStatus,
  });

  Future<Either<AccountFailure, Unit>> deleteAccount({required String id});

  Future<Either<AccountFailure, List<StatusEntity>>> getStatuses({
    required int accountId,
  });
  Future<Either<AccountFailure, Unit>> createStatus({
    required String privacy,
    String? text,
    File? media,
  });

  Future<Either<AccountFailure, Unit>> deleteStatus({required int statusId});

  //? phase 2 methods:

  Future<Either<AccountFailure, PaginatedSimplifiedAccountEntity>>
  searchAccounts({required String query, required int pageNum});
}
