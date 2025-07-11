part of 'personal_account_bloc.dart';

abstract class PAccountEvent extends Equatable {
  const PAccountEvent();

  @override
  List<Object> get props => [];
}

class DefinePAccountCurrentStateEvent extends PAccountEvent {}

class LoadRemotePAccountEvent extends PAccountEvent {}

class UpdatePAccountEvent extends PAccountEvent {
  final PersonalAccountEntity personalAccount;
  final File? profilePic;

  const UpdatePAccountEvent({required this.personalAccount, this.profilePic});

  @override
  List<Object> get props => [personalAccount];
}

class DeletePAccountEvent extends PAccountEvent {}
