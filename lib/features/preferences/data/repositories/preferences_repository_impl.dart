import 'package:dartz/dartz.dart';
import 'package:realmo/core/errors/exceptions/preferences_exception.dart';
import 'package:realmo/core/errors/failures/preferences_failure.dart';
import 'package:realmo/features/preferences/data/data_soucres/preferences_local_data_source.dart';
import 'package:realmo/features/preferences/domain/entities/preferences_entity.dart';
import 'package:realmo/features/preferences/domain/repositories/preferences_repository.dart';
import 'package:realmo/features/preferences/data/models/preferences_model.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final PreferencesLocalDataSource localDataSource;

  PreferencesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<PreferencesFailure, PreferencesEntity>>
  loadPreferences() async {
    try {
      final PreferencesModel model = await localDataSource.loadPreferences();
      return Right(model);
    } on PreferencesException catch (e) {
      return Left(PreferencesFailure(e.message));
    } catch (e) {
      return Left(PreferencesFailure(e.toString()));
    }
  }

  @override
  Future<Either<PreferencesFailure, Unit>> storePreferences(
    PreferencesEntity preferences,
  ) async {
    try {
      final PreferencesModel model = PreferencesModel.fromEntity(preferences);
      await localDataSource.storePreferences(model);
      return Right(unit);
    } on PreferencesException catch (e) {
      return Left(PreferencesFailure(e.message));
    } catch (e) {
      return Left(PreferencesFailure(e.toString()));
    }
  }
}
