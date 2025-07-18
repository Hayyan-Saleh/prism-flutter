part of 'personal_account_bloc.dart';

abstract class PAccountState extends Equatable {
  const PAccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends PAccountState {}

class LoadingPAccountState extends PAccountState {}

class LoadedPAccountState extends PAccountState {
  final PersonalAccountEntity personalAccount;

  const LoadedPAccountState({required this.personalAccount});

  @override
  List<Object> get props => [personalAccount];
}

class PAccountNotCreatedState extends PAccountState {}

class FailedPAccountState extends PAccountState {
  final AppFailure failure;

  const FailedPAccountState({required this.failure});

  @override
  List<Object> get props => [failure];
}

class DoneUpdatePAccountState extends PAccountState {}

class PAccountDeletedState extends PAccountState {}
