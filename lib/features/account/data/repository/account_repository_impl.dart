import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/exceptions/account_exception.dart';
import 'package:prism/core/errors/exceptions/server_exception.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/core/util/sevices/token_service.dart';
import 'package:prism/features/account/data/data-sources/account_remote_data_source.dart';
import 'package:prism/features/account/data/data-sources/personal_account_local_data_source.dart';
import 'package:prism/features/account/data/models/account/main/group_model.dart';
import 'package:prism/features/account/data/models/account/main/personal_account_model.dart';
import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/data/models/account/status/status_model.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/main/join_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/main/other_account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/paginated_simplified_account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';
import 'package:prism/features/auth/data/datasources/user_local_data_source.dart';
import 'package:prism/features/auth/domain/usecases/load_user_use_case.dart';
import '../../domain/enitities/account/highlight/detailed_highlight_entity.dart';
import '../../domain/enitities/account/highlight/highlight_entity.dart';
import '../../domain/enitities/account/main/group_entity.dart';
import '../../domain/enitities/account/simplified/paginated_groups_entity.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;
  final PersonalAccountLocalDataSource personalAccLDS;

  final UserLocalDataSource authLDS;
  final LoadUserUseCase loadUser;
  final TokenService tokenService;

  AccountRepositoryImpl({
    required this.remoteDataSource,
    required this.personalAccLDS,
    required this.tokenService,
    required this.loadUser,
    required this.authLDS,
  });

  Future<Either<AccountFailure, String>> _getToken() async {
    final tokenResult = await tokenService.getToken();
    return tokenResult.fold(
      (failure) => Left(AccountFailure(failure.message)),
      (token) => Right(token),
    );
  }

  Future<Either<AccountFailure, Unit>> _storeToken({
    required String newToken,
  }) async {
    final tokenResult = await tokenService.storeNewToken(newToken: newToken);
    return tokenResult.fold(
      (failure) => Left(AccountFailure(failure.message)),
      (token) => Right(unit),
    );
  }

  Future<Either<AccountFailure, T>> _withToken<T>(
    Future<Either<AccountFailure, T>> Function(String token) operation,
  ) async {
    try {
      final tokenResult = await _getToken();
      return tokenResult.fold((failure) => Left(failure), operation);
    } catch (e) {
      return Left(AccountFailure(e.toString()));
    }
  }

  @override
  Future<Either<AccountFailure, bool>> checkAccountName({
    required String accountName,
  }) async {
    return _withToken((token) async {
      final isAvailable = await remoteDataSource.checkAccountName(
        token: token,
        accountName: accountName,
      );
      return Right(isAvailable);
    });
  }

  @override
  Future<Either<AccountFailure, PersonalAccountEntity>> updatePersonalAccount({
    required File? profilePic,
    required PersonalAccountEntity personalAccount,
  }) async {
    return _withToken((token) async {
      final frontendModel = PersonalAccountModel.fromEntity(personalAccount);
      final result = await remoteDataSource.editPersonalAccount(
        token: token,
        profilePic: profilePic,
        personalAccount: frontendModel,
      );

      final String newToken = result['token'];
      final either = await _storeToken(newToken: newToken);
      return either.fold((failure) => Left(failure), (_) async {
        final PersonalAccountModel backendModel = PersonalAccountModel.fromJson(
          result['user'],
        );
        await personalAccLDS.storeAccount(backendModel);
        return Right(backendModel.toEntity());
      });
    });
  }

  @override
  Future<Either<AccountFailure, PersonalAccountEntity?>>
  getLocalPersonalAccount() async {
    try {
      final PersonalAccountModel? model = await personalAccLDS.getAccount();
      return Right(model?.toEntity());
    } catch (e) {
      return Left(AccountFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, PersonalAccountEntity>>
  getRemotePersonalAccount() async {
    try {
      final loadedUserResult = await loadUser();
      return loadedUserResult.fold((failure) => Left(failure), (
        loadedUser,
      ) async {
        return _withToken((token) async {
          try {
            final model = await remoteDataSource.getRemotePersonalAccount(
              token: token,
              id: loadedUser.id,
            );
            await personalAccLDS.storeAccount(model);
            return Right(model.toEntity());
          } on AccountException catch (e) {
            return Left(AccountFailure(e.message));
          } catch (e) {
            return Left(AccountFailure(e.toString()));
          }
        });
      });
    } catch (e) {
      return Left(AccountFailure(e.toString()));
    }
  }

  @override
  Future<Either<AccountFailure, OtherAccountEntity>> getOtherAccount({
    required int id,
  }) async {
    return _withToken((token) async {
      final result = await remoteDataSource.getOtherAccount(
        token: token,
        id: id,
      );
      return result.fold(
        (failure) => Left(AccountFailure(failure.message)),
        (model) => Right(model.toEntity()),
      );
    });
  }

  @override
  Future<Either<AppFailure, FollowStatus>> updateFollowingStatus({
    required int targetId,
    required bool newStatus,
  }) async {
    return _withToken((token) async {
      try {
        final result = await remoteDataSource.updateAccountFollowingStatus(
          token: token,
          targetId: targetId,
          newStatus: newStatus,
        );
        return Right(result);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> createStatus({
    required String privacy,
    String? text,
    File? media,
  }) async {
    return _withToken((token) async {
      try {
        await remoteDataSource.createStatus(
          token: token,
          privacy: privacy,
          media: media,
          text: text,
        );
        return Right(unit);
      } on AccountException catch (e) {
        return left(AccountFailure(e.message));
      } catch (e) {
        return left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> deleteStatus({
    required int statusId,
  }) async {
    return _withToken((token) async {
      await remoteDataSource.deleteStatus(token: token, statusId: statusId);
      return Right(unit);
    });
  }

  @override
  Future<Either<AccountFailure, List<StatusEntity>>> getStatuses({
    required int accountId,
  }) async {
    return _withToken((token) async {
      final List<StatusModel> statuses = await remoteDataSource.getStatuses(
        token: token,
        accountId: accountId,
      );
      return Right(statuses);
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> deleteAccount() async {
    return _withToken((token) async {
      try {
        await remoteDataSource.deleteAccount(token: token);
        await personalAccLDS.clearAccount();
        await tokenService.deleteUserToken();
        await authLDS.clearSession();
        return const Right(unit);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, PaginatedSimplifiedAccountEntity>>
  searchAccounts({required String query, required int pageNum}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<AccountFailure, List<SimplifiedAccountModel>>> getFollowers({
    required int accountId,
  }) {
    return _withToken((token) async {
      try {
        final List<SimplifiedAccountModel> followers = await remoteDataSource
            .getFollowers(token: token, accountId: accountId);
        return Right(followers.toList());
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, List<SimplifiedAccountModel>>> getFollowing({
    required int accountId,
  }) {
    return _withToken((token) async {
      try {
        final List<SimplifiedAccountModel> following = await remoteDataSource
            .getFollowings(token: token, accountId: accountId);
        return Right(following);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, List<SimplifiedAccountModel>>>
  getFollowingStatuses() async {
    return _withToken((token) async {
      try {
        final accounts = await remoteDataSource.getFollowingStatuses(
          token: token,
        );
        return Right(accounts);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> blockUser({required int targetId}) {
    return _withToken((token) async {
      try {
        await remoteDataSource.blockUser(token: token, targetId: targetId);
        return Right(unit);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> unblockUser({required int targetId}) {
    return _withToken((token) async {
      try {
        await remoteDataSource.unblockUser(token: token, targetId: targetId);
        return Right(unit);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, List<SimplifiedAccountModel>>>
  getBlockedAccounts() {
    return _withToken((token) async {
      try {
        final accounts = await remoteDataSource.getBlockedAccounts(
          token: token,
        );
        return Right(accounts);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, List<StatusEntity>>> getArchivedStatuses() {
    return _withToken((token) async {
      try {
        final statuses = await remoteDataSource.getArchivedStatuses(
          token: token,
        );
        return Right(statuses.map((model) => model).toList());
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> createHighlight({
    required List<int> statusIds,
    String? text,
    File? cover,
  }) {
    return _withToken((token) async {
      try {
        await remoteDataSource.createHighlight(
          token: token,
          statusIds: statusIds,
          text: text,
          cover: cover,
        );
        return const Right(unit);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> toggleLikeStatus({
    required int statusId,
  }) {
    return _withToken((token) async {
      try {
        await remoteDataSource.toggleLikeStatus(
          token: token,
          statusId: statusId,
        );
        return const Right(unit);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, List<SimplifiedAccountModel>>> getStatusLikers({
    required int statusId,
  }) {
    return _withToken((token) async {
      try {
        final likers = await remoteDataSource.getStatusLikers(
          token: token,
          statusId: statusId,
        );
        return Right(likers);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, List<HighlightEntity>>> getHighlights({
    int? accountId,
  }) {
    return _withToken((token) async {
      try {
        final highlights = await remoteDataSource.getHighlights(
          token: token,
          accountId: accountId,
        );
        return Right(highlights);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, DetailedHighlightEntity>> getDetailedHighlight({
    required int highlightId,
  }) {
    return _withToken((token) async {
      try {
        final highlight = await remoteDataSource.getDetailedHighlight(
          token: token,
          highlightId: highlightId,
        );
        return Right(highlight);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> deleteHighlight({
    required int highlightId,
  }) {
    return _withToken((token) async {
      try {
        await remoteDataSource.deleteHighlight(
          token: token,
          highlightId: highlightId,
        );
        return const Right(unit);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> updateHighlightCover({
    required int highlightId,
    required File cover,
  }) {
    return _withToken((token) async {
      try {
        await remoteDataSource.updateHighlightCover(
          token: token,
          highlightId: highlightId,
          cover: cover,
        );
        return Right(unit);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> addToHighlight({
    required int highlightId,
    required int statusId,
  }) {
    return _withToken((token) async {
      try {
        await remoteDataSource.addToHighlight(
          token: token,
          highlightId: highlightId,
          statusId: statusId,
        );
        return const Right(unit);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, GroupEntity>> createGroup({
    required String name,
    required String privacy,
    File? avatar,
    String? bio,
  }) async {
    return _withToken((token) async {
      try {
        final GroupModel group = await remoteDataSource.createGroup(
          token: token,
          name: name,
          privacy: privacy,
          avatar: avatar,
          bio: bio,
        );
        return Right(group.toEntity());
      } on ServerException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, GroupEntity>> getGroup({required int groupId}) {
    return _withToken((token) async {
      try {
        final group = await remoteDataSource.getGroup(
          token: token,
          groupId: groupId,
        );
        return Right(group);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, PaginatedGroupsEntity>> getOwnedGroups({
    required int page,
  }) {
    return _withToken((token) async {
      try {
        final groups = await remoteDataSource.getOwnedGroups(
          token: token,
          page: page,
        );
        return Right(groups);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, PaginatedGroupsEntity>> getFollowedGroups({
    required int page,
  }) {
    return _withToken((token) async {
      try {
        final groups = await remoteDataSource.getFollowedGroups(
          token: token,
          page: page,
        );
        return Right(groups);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> updateGroup({
    required int groupId,
    String? name,
    String? privacy,
    File? avatar,
    String? bio,
  }) {
    return _withToken((token) async {
      try {
        await remoteDataSource.updateGroup(
          token: token,
          groupId: groupId,
          name: name,
          privacy: privacy,
          avatar: avatar,
          bio: bio,
        );
        return Right(unit);
      } on ServerException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, Unit>> deleteGroup({required int groupId}) {
    return _withToken((token) async {
      try {
        await remoteDataSource.deleteGroup(token: token, groupId: groupId);
        return Right(unit);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AppFailure, JoinStatus>> updateGroupMembershipStatus({
    required int groupId,
    required bool join,
  }) {
    return _withToken((token) async {
      try {
        final result = await remoteDataSource.updateGroupMembershipStatus(
          token: token,
          groupId: groupId,
          join: join,
        );
        return Right(result);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      }
    });
  }

  @override
  Future<Either<AccountFailure, PaginatedGroupsEntity>> exploreGroups({
    required int page,
  }) {
    return _withToken((token) async {
      try {
        final groups = await remoteDataSource.exploreGroups(
          token: token,
          page: page,
        );
        return Right(groups);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<AccountFailure, List<SimplifiedAccountModel>>> getGroupMembers({
    required int groupId,
  }) {
    return _withToken((token) async {
      try {
        final members = await remoteDataSource.getGroupMembers(
          token: token,
          groupId: groupId,
        );
        return Right(members);
      } on AccountException catch (e) {
        return Left(AccountFailure(e.message));
      } catch (e) {
        return Left(AccountFailure(e.toString()));
      }
    });
  }
}
