import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/use-cases/account/create_highlight_usecase.dart';

part 'highlight_event.dart';
part 'highlight_state.dart';

class HighlightBloc extends Bloc<HighlightEvent, HighlightState> {
  final CreateHighlightUseCase createHighlightUseCase;

  HighlightBloc({required this.createHighlightUseCase})
    : super(HighlightInitial()) {
    on<CreateHighlight>(_onCreateHighlight);
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
}
