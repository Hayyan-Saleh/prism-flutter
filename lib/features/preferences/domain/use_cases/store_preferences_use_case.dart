import 'package:dartz/dartz.dart';
import 'package:prism/core/errors/failures/preferences_failure.dart';
import 'package:prism/features/preferences/domain/entities/preferences_entity.dart';
import 'package:prism/features/preferences/domain/repositories/preferences_repository.dart';

class StorePreferencesUseCase {
  final PreferencesRepository repository;

  StorePreferencesUseCase({required this.repository});

  Future<Either<PreferencesFailure, Unit>> call(
    PreferencesEntity preferences,
  ) async {
    return await repository.storePreferences(preferences);
  }
}
