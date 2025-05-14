part of 'preferences_bloc.dart';

sealed class PreferencesEvent extends Equatable {
  const PreferencesEvent();

  @override
  List<Object> get props => [];
}

final class StorePreferencesEvent extends PreferencesEvent {
  final PreferencesEntity preferences;

  const StorePreferencesEvent({required this.preferences});

  @override
  List<Object> get props => [preferences];
}
