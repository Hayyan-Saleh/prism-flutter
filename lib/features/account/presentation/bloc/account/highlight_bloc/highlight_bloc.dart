import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/detailed_highlight_entity.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/highlight_entity.dart';
import 'package:prism/features/account/domain/use-cases/account/create_highlight_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/delete_highlight_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_detailed_highlight_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_highlights_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/update_highlight_cover_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/add_to_highlight_usecase.dart';
part 'highlight_event.dart';
part 'highlight_state.dart';

class HighlightBloc extends Bloc<HighlightEvent, HighlightState> {
  final CreateHighlightUseCase createHighlightUseCase;
  final GetHighlightsUsecase getHighlightsUsecase;
  final GetDetailedHighlightUsecase getDetailedHighlightUsecase;
  final DeleteHighlightUseCase deleteHighlightUseCase;
  final UpdateHighlightCoverUseCase updateHighlightCoverUseCase;
  final AddToHighlightUseCase addToHighlightUseCase;

  HighlightBloc({
    required this.createHighlightUseCase,
    required this.getHighlightsUsecase,
    required this.getDetailedHighlightUsecase,
    required this.deleteHighlightUseCase,
    required this.updateHighlightCoverUseCase,
    required this.addToHighlightUseCase,
  }) : super(HighlightInitial()) {
    on<CreateHighlight>(_onCreateHighlight);
    on<GetHighlights>(_onGetHighlights);
    on<GetDetailedHighlight>(_onGetDetailedHighlight);
    on<DeleteHighlight>(_onDeleteHighlight);
    on<UpdateHighlightCover>(_onUpdateHighlightCover);
    on<AddToHighlight>(_onAddToHighlight);
  }

  Future<void> _onCreateHighlight(
    CreateHighlight event,
    Emitter<HighlightState> emit,
  ) async {
    emit(HighlightLoading());
    final result = await createHighlightUseCase(
      statusIds: event.statusIds,
      text: event.text,
      cover: event.cover,
    );
    result.fold(
      (failure) => emit(HighlightFailure(message: failure.message)),
      (_) => emit(HighlightCreated()),
    );
  }

  Future<void> _onGetHighlights(
    GetHighlights event,
    Emitter<HighlightState> emit,
  ) async {
    emit(HighlightLoading());
    final result = await getHighlightsUsecase(accountId: event.accountId);
    result.fold(
      (failure) => emit(HighlightFailure(message: failure.message)),
      (highlights) => emit(HighlightsLoaded(highlights: highlights)),
    );
  }

  Future<void> _onGetDetailedHighlight(
    GetDetailedHighlight event,
    Emitter<HighlightState> emit,
  ) async {
    emit(HighlightLoading());
    final result = await getDetailedHighlightUsecase(
      highlightId: event.highlightId,
    );
    result.fold(
      (failure) => emit(HighlightFailure(message: failure.message)),
      (highlight) => emit(DetailedHighlightLoaded(highlight: highlight)),
    );
  }

  Future<void> _onDeleteHighlight(
    DeleteHighlight event,
    Emitter<HighlightState> emit,
  ) async {
    emit(HighlightLoading());
    final result = await deleteHighlightUseCase(highlightId: event.highlightId);
    result.fold(
      (failure) => emit(HighlightFailure(message: failure.message)),
      (_) => emit(HighlightDeleted()),
    );
  }

  Future<void> _onUpdateHighlightCover(
    UpdateHighlightCover event,
    Emitter<HighlightState> emit,
  ) async {
    emit(HighlightLoading());
    final result = await updateHighlightCoverUseCase(
      highlightId: event.highlightId,
      cover: event.cover,
    );
    result.fold(
      (failure) => emit(HighlightFailure(message: failure.message)),
      (_) => emit(HighlightCoverUpdated()),
    );
  }

  Future<void> _onAddToHighlight(
    AddToHighlight event,
    Emitter<HighlightState> emit,
  ) async {
    emit(HighlightLoading());
    final result = await addToHighlightUseCase(
      highlightId: event.highlightId,
      statusId: event.statusId,
    );
    result.fold(
      (failure) => emit(HighlightFailure(message: failure.message)),
      (_) => emit(HighlightAddedTo()),
    );
  }
}
