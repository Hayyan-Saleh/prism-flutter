part of 'account_name_bloc.dart';

sealed class AccountNameEvent extends Equatable {
  const AccountNameEvent();

  @override
  List<Object> get props => [];
}

class CheckAccountNameEvent extends AccountNameEvent {
  final String accountName;

  const CheckAccountNameEvent({required this.accountName});
}

class ResetEvent extends AccountNameEvent {}
