import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/domain/entities/theme_entity.dart';
import 'package:test1/domain/entities/locale_entity.dart';
import 'package:test1/domain/usecases/get_theme_usecase.dart';
import 'package:test1/domain/usecases/save_theme_usecase.dart';
import 'package:test1/domain/usecases/get_locale_usecase.dart';
import 'package:test1/domain/usecases/save_locale_usecase.dart';
import 'package:test1/presentation/bloc/settings_events.dart';
import 'package:test1/presentation/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetThemeUsecase getThemeUsecase;
  final SaveThemeUsecase saveThemeUsecase;
  final GetLocaleUsecase getLocaleUsecase;
  final SaveLocaleUsecase saveLocaleUsecase;

  SettingsBloc({
    required this.getThemeUsecase,
    required this.saveThemeUsecase,
    required this.getLocaleUsecase,
    required this.saveLocaleUsecase,
  }) : super(SettingsState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ChangeLocaleEvent>(_onChangeLocale);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final theme = await getThemeUsecase();
      final locale = await getLocaleUsecase();
      emit(
        state.copyWith(
          status: SettingsStatus.success,
          theme: theme,
          locale: locale,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state.theme != null) {
      final newThemeType =
          state.theme!.themeType == ThemeType.dark
              ? ThemeType.light
              : ThemeType.dark;
      final newTheme = ThemeEntity(themeType: newThemeType);

      try {
        await saveThemeUsecase(newTheme);
        emit(state.copyWith(theme: newTheme, status: SettingsStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: SettingsStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await saveLocaleUsecase(event.locale);
      emit(
        state.copyWith(locale: event.locale, status: SettingsStatus.success),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
