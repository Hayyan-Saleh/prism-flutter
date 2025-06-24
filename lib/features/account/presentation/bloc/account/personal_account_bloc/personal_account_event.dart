part of 'personal_account_bloc.dart';

sealed class PAccountEvent extends Equatable {
  const PAccountEvent();

  @override
  List<Object> get props => [];
}

class DefinePAccountCurrentStateEvent extends PAccountEvent {}

class UpdatePAccountEvent extends PAccountEvent {
  final File? profilePic;
  final PersonalAccountEntity personalAccount;

  const UpdatePAccountEvent({
    required this.profilePic,
    required this.personalAccount,
  });

  @override
  List<Object> get props =>
      profilePic == null ? [personalAccount] : [personalAccount, profilePic!];
}

class LoadPAccountEvent extends PAccountEvent {}

class LoadRemotePAccountEvent extends PAccountEvent {}
