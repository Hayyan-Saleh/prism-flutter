import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';
import 'package:prism/features/account/domain/use-cases/account/create_status_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/delete_status_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_statuses_usecase.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final CreateStatusUseCase createStatusUseCase;
  final DeleteStatusUsecase deleteStatusUseCase;
  final GetStatusesUsecase getStatusesUseCase;

  StatusBloc({
    required this.createStatusUseCase,
    required this.deleteStatusUseCase,
    required this.getStatusesUseCase,
  }) : super(StatusInitial()) {
    on<CreateStatusEvent>(_onCreateStatus);
    on<DeleteStatusEvent>(_onDeleteStatus);
    on<GetStatusesEvent>(_onGetStatuses);
  }

  Future<void> _onCreateStatus(
    CreateStatusEvent event,
    Emitter<StatusState> emit,
  ) async {
    emit(StatusLoading());
    final result = await createStatusUseCase(
      privacy: event.privacy,
      text: event.text,
      media: event.media,
    );
    emit(
      result.fold(
        (failure) => StatusFailure(error: failure.message),
        (_) => StatusCreated(),
      ),
    );
  }

  Future<void> _onDeleteStatus(
    DeleteStatusEvent event,
    Emitter<StatusState> emit,
  ) async {
    emit(StatusLoading());
    final result = await deleteStatusUseCase(statusId: event.statusId);
    emit(
      result.fold(
        (failure) => StatusFailure(error: failure.message),
        (_) => StatusDeleted(),
      ),
    );
  }

  Future<void> _onGetStatuses(
    GetStatusesEvent event,
    Emitter<StatusState> emit,
  ) async {
    emit(StatusLoading());
    final result = await getStatusesUseCase(accountId: event.accountId);
    emit(
      result.fold(
        (failure) => StatusFailure(error: failure.message),
        (statuses) => StatusLoaded(statuses: statuses),
      ),
    );
  }
}
