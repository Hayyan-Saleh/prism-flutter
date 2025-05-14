part of 'preferences_bloc.dart';

sealed class PreferencesState extends Equatable {
  const PreferencesState();

  @override
  List<Object> get props => [];
}

final class PreferencesInitial extends PreferencesState {}

final class LoadingStorePreferencesState extends PreferencesState {}

final class DoneStorePreferencesState extends PreferencesState {}

final class FailedStorePreferencesState extends PreferencesState {
  final PreferencesFailure failure;

  const FailedStorePreferencesState({required this.failure});
  @override
  List<Object> get props => [failure];
}
