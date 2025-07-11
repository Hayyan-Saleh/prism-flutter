part of 'accounts_bloc.dart';

sealed class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object> get props => [];
}

class GetFollowersAccountsEvent extends AccountsEvent {
  final int accountId;

  const GetFollowersAccountsEvent({required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class GetFollowingAccountsEvent extends AccountsEvent {
  final int accountId;

  const GetFollowingAccountsEvent({required this.accountId});

  @override
  List<Object> get props => [accountId];
}
