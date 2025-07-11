part of 'account_name_bloc.dart';

sealed class AccountNameState extends Equatable {
  const AccountNameState();

  @override
  List<Object> get props => [];
}

final class AccountNameInitial extends AccountNameState {}

class LoadingAccountNameState extends AccountNameState {}

class AvailableAccountNameState extends AccountNameState {}

class UnavailableAccountNameState extends AccountNameState {}

class FailedAccountNameState extends AccountNameState {
  final AccountFailure failure;

  const FailedAccountNameState({required this.failure});

  @override
  List<Object> get props => [failure];
}
