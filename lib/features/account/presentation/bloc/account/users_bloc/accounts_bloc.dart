import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/domain/use-cases/account/get_followers_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_following_usecase.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final GetFollowersUsecase getFollowers;
  final GetFollowingUsecase getFollowing;

  AccountsBloc({required this.getFollowers, required this.getFollowing})
    : super(AccountsInitial()) {
    on<GetFollowersAccountsEvent>(_onGetFollowers);
    on<GetFollowingAccountsEvent>(_onGetFollowing);
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
}
