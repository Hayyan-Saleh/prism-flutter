part of 'status_bloc.dart';

sealed class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object?> get props => [];
}

class CreateStatusEvent extends StatusEvent {
  final String privacy;
  final String? text;
  final File? media;

  const CreateStatusEvent({required this.privacy, this.text, this.media});

  @override
  List<Object?> get props => [privacy, text, media];
}

class DeleteStatusEvent extends StatusEvent {
  final int statusId;

  const DeleteStatusEvent({required this.statusId});

  @override
  List<Object> get props => [statusId];
}

class GetStatusesEvent extends StatusEvent {
  final int accountId;

  const GetStatusesEvent({required this.accountId});

  @override
  List<Object> get props => [accountId];
}
