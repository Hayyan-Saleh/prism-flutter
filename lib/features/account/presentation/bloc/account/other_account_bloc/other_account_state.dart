part of 'other_account_bloc.dart';

sealed class OAccountState extends Equatable {
  const OAccountState();

  @override
  List<Object> get props => [];
}

final class OAccountInitial extends OAccountState {}

class LoadingOAccountState extends OAccountState {}

class LoadedOAccountState extends OAccountState {
  final OtherAccountEntity otherAccount;

  const LoadedOAccountState({required this.otherAccount});
}

class FailedOAccountState extends OAccountState {
  final AppFailure failure;

  const FailedOAccountState({required this.failure});
  @override
  List<Object> get props => [failure];
}

class UserBlockedState extends OAccountState {}

class UserUnblockedState extends OAccountState {}
