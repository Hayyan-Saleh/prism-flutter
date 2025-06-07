import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/core/errors/failures/preferences_failure.dart';
import 'package:prism/core/util/constants/strings.dart';
import 'package:prism/features/preferences/domain/entities/preferences_entity.dart';
import 'package:prism/features/preferences/domain/use_cases/load_preferences_use_case.dart';
import 'package:prism/features/preferences/domain/use_cases/store_preferences_use_case.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final StorePreferencesUseCase storePreferencesUseCase;
  final LoadPreferencesUseCase loadPreferencesUseCase;
  PreferencesBloc({
    required this.storePreferencesUseCase,
    required this.loadPreferencesUseCase,
  }) : super(PreferencesInitial()) {
    on<PreferencesEvent>((event, emit) async {
      if (event is DefinePreferencesCurrentStateEvent) {
        final either = await loadPreferencesUseCase();
        either.fold(
          (failure) {
            if (failure.message == EMPTY_PREFRENCES_MSG) {
              emit(StartingWalkthroughState());
            } else {
              emit(FailedStorePreferencesState(failure: failure));
            }
          },
          (preferences) =>
              emit(LoadedPreferencesState(preferences: preferences)),
        );
      } else if (event is StorePreferencesEvent) {
        emit(LoadingStorePreferencesState());
        final result = await storePreferencesUseCase(event.preferences);

        result.fold(
          (failure) => emit(FailedStorePreferencesState(failure: failure)),
          (_) =>
              emit(DoneStorePreferencesState(preferences: event.preferences)),
        );
      }
    });
  }
}
