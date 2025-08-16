part of 'preferences_bloc.dart';

sealed class PreferencesState extends Equatable {
  const PreferencesState();

  @override
  List<Object> get props => [];
}

final class PreferencesInitial extends PreferencesState {}

final class LoadedPreferencesState extends PreferencesState {
  final PreferencesEntity preferences;

  const LoadedPreferencesState({required this.preferences});

  @override
  List<Object> get props => [preferences];
}

final class StartingWalkthroughState extends PreferencesState {}

final class LoadingStorePreferencesState extends PreferencesState {}

final class DoneStorePreferencesState extends PreferencesState {
  final PreferencesEntity preferences;

  const DoneStorePreferencesState({required this.preferences});

  @override
  List<Object> get props => [preferences];
}

final class FailedStorePreferencesState extends PreferencesState {
  final PreferencesFailure failure;

  const FailedStorePreferencesState({required this.failure});
  @override
  List<Object> get props => [failure];
}
