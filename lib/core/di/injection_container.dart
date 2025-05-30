import 'package:get_it/get_it.dart';
import 'package:realmo/features/preferences/data/data_soucres/preferences_local_data_source.dart';
import 'package:realmo/features/preferences/data/repositories/preferences_repository_impl.dart';
import 'package:realmo/features/preferences/domain/repositories/preferences_repository.dart';
import 'package:realmo/features/preferences/domain/use_cases/load_preferences_use_case.dart';
import 'package:realmo/features/preferences/domain/use_cases/store_preferences_use_case.dart';
import 'package:realmo/features/preferences/presentation/bloc/preferences_bloc/preferences_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! preferences

  // Bloc
  sl.registerFactory(() => PreferencesBloc(storePreferencesUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoadPreferencesUseCase(repository: sl()));
  sl.registerLazySingleton(() => StorePreferencesUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<PreferencesRepository>(
    () => PreferencesRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PreferencesLocalDataSource>(
    () => PreferencesLocalDataSourceImpl(),
  );
}
