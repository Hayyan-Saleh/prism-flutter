import 'package:dartz/dartz.dart';
import 'package:realmo/core/errors/failures/preferences_failure.dart';
import 'package:realmo/features/preferences/domain/entities/preferences_entity.dart';
import 'package:realmo/features/preferences/domain/repositories/preferences_repository.dart';

class LoadPreferencesUseCase {
  final PreferencesRepository repository;

  LoadPreferencesUseCase({required this.repository});

  Future<Either<PreferencesFailure, PreferencesEntity>> call() async {
    return await repository.loadPreferences();
  }
}
