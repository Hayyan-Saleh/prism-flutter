part of 'status_bloc.dart';

abstract class StatusState extends Equatable {
  const StatusState();

  @override
  List<Object> get props => [];
}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusCreated extends StatusState {}

class StatusDeleted extends StatusState {}

class StatusLoaded extends StatusState {
  final List<StatusEntity> statuses;

  const StatusLoaded({required this.statuses});

  @override
  List<Object> get props => [statuses];
}

class StatusFailure extends StatusState {
  final String error;

  const StatusFailure({required this.error});

  @override
  List<Object> get props => [error];
}
