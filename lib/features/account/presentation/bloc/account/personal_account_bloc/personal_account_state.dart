part of 'personal_account_bloc.dart';

sealed class PAccountState extends Equatable {
  const PAccountState();

  @override
  List<Object> get props => [];
}

final class AccountInitial extends PAccountState {}

class LoadingPAccountState extends PAccountState {}

class LoadedPAccountState extends PAccountState {
  final PersonalAccountEntity personalAccount;

  const LoadedPAccountState({required this.personalAccount});
}

class PAccountNotCreatedState extends PAccountState {}

class DoneUpdatePAccountState extends PAccountState {}

class FailedPAccountState extends PAccountState {
  final AppFailure failure;

  const FailedPAccountState({required this.failure});
  @override
  List<Object> get props => [failure];
}
