part of 'other_account_bloc.dart';

sealed class OAccountEvent extends Equatable {
  const OAccountEvent();

  @override
  List<Object> get props => [];
}

class LoadOAccountEvent extends OAccountEvent {
  final int id;

  const LoadOAccountEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class BlockUserEvent extends OAccountEvent {
  final int targetId;

  const BlockUserEvent({required this.targetId});

  @override
  List<Object> get props => [targetId];
}

class UnblockUserEvent extends OAccountEvent {
  final bool fromDetailedPage;
  final int targetId;

  const UnblockUserEvent({
    required this.targetId,
    this.fromDetailedPage = false,
  });

  @override
  List<Object> get props => [targetId];
}
