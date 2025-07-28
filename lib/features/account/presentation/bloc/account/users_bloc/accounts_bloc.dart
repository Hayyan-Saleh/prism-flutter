import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/domain/use-cases/account/get_followers_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_following_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_group_members_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_status_likers_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_blocked_accounts_usecase.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final GetFollowersUsecase getFollowers;
  final GetFollowingUsecase getFollowing;
  final GetBlockedAccountsUseCase getBlocked;
  final GetStatusLikersUseCase getStatusLikers;
  final GetGroupMembersUseCase getGroupMembers;

  AccountsBloc({
    required this.getFollowers,
    required this.getFollowing,
    required this.getBlocked,
    required this.getStatusLikers,
    required this.getGroupMembers,
  }) : super(AccountsInitial()) {
    on<GetFollowersAccountsEvent>(_onGetFollowers);
    on<GetFollowingAccountsEvent>(_onGetFollowing);
    on<GetBlockedAccountsEvent>(_onGetBlocked);
    on<GetStatusLikersEvent>(_onGetStatusLikers);
    on<GetGroupMembersEvent>(_onGetGroupMembers);
  }

  Future<void> _onGetFollowers(
    GetFollowersAccountsEvent event,
    Emitter<AccountsState> emit,
  ) async {
    emit(LoadingAccountsState());
    final either = await getFollowers(accountId: event.accountId);
    either.fold(
      (failure) => emit(FailedAccountsState(failure: failure)),
      (accounts) => emit(LoadedAccountsState(accounts: accounts)),
    );
  }

  Future<void> _onGetFollowing(
    GetFollowingAccountsEvent event,
    Emitter<AccountsState> emit,
  ) async {
    emit(LoadingAccountsState());
    final either = await getFollowing(accountId: event.accountId);
    either.fold(
      (failure) => emit(FailedAccountsState(failure: failure)),
      (accounts) => emit(LoadedAccountsState(accounts: accounts)),
    );
  }

  Future<void> _onGetBlocked(
    GetBlockedAccountsEvent event,
    Emitter<AccountsState> emit,
  ) async {
    emit(LoadingAccountsState());
    final result = await getBlocked();
    result.fold(
      (failure) => emit(BlockedAccountsError(message: failure.message)),
      (accounts) => emit(BlockedAccountsLoaded(blockedAccounts: accounts)),
    );
  }

  Future<void> _onGetStatusLikers(
    GetStatusLikersEvent event,
    Emitter<AccountsState> emit,
  ) async {
    emit(LoadingAccountsState());
    final either = await getStatusLikers(event.statusId);
    either.fold(
      (failure) =>
          emit(FailedAccountsState(failure: failure as AccountFailure)),
      (accounts) => emit(LoadedAccountsState(accounts: accounts)),
    );
  }

  Future<void> _onGetGroupMembers(
    GetGroupMembersEvent event,
    Emitter<AccountsState> emit,
  ) async {
    emit(LoadingAccountsState());
    final either = await getGroupMembers(groupId: event.groupId);
    either.fold(
      (failure) => emit(FailedAccountsState(failure: failure)),
      (accounts) => emit(LoadedAccountsState(accounts: accounts)),
    );
  }
}
