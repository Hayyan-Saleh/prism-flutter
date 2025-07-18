part of 'accounts_bloc.dart';

sealed class AccountsState extends Equatable {
  const AccountsState();

  @override
  List<Object> get props => [];
}

final class AccountsInitial extends AccountsState {}

class LoadingAccountsState extends AccountsState {}

class LoadedAccountsState extends AccountsState {
  final List<SimplifiedAccountEntity> accounts;

  const LoadedAccountsState({required this.accounts});

  @override
  List<Object> get props => [accounts];
}

class FailedAccountsState extends AccountsState {
  final AccountFailure failure;

  const FailedAccountsState({required this.failure});

  @override
  List<Object> get props => [failure];
}

class BlockedAccountsLoaded extends AccountsState {
  final List<SimplifiedAccountEntity> blockedAccounts;

  const BlockedAccountsLoaded({required this.blockedAccounts});

  @override
  List<Object> get props => [blockedAccounts];
}

class BlockedAccountsError extends AccountsState {
  final String message;

  const BlockedAccountsError({required this.message});

  @override
  List<Object> get props => [message];
}
