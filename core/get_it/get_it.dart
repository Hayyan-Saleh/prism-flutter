import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/data/datasource/settings_local_data_source.dart';
import 'package:test1/data/repository/settings_repository_impl.dart';
import 'package:test1/domain/repositories/settings_repository.dart';
import 'package:test1/domain/usecases/get_theme_usecase.dart';
import 'package:test1/domain/usecases/save_theme_usecase.dart';
import 'package:test1/presentation/bloc/settings_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // 1. Register SharedPreferences
  getIt.registerLazySingleton(await SharedPreferences.getInstance);

  // 2. Register Data Source
  getIt.registerSingleton<SettingsLocalDataSource>(
    SettingsLocalDataSource(prefs: getIt()),
  );

  // 3. Register Repository
  getIt.registerSingleton<SettingsRepository>(
    SettingsRepositoryImpl(dataSource: getIt()),
  );

  // 4. Register Theme Use Cases
  getIt.registerSingleton(GetThemeUseCase(repository: getIt()));
  getIt.registerSingleton(SaveThemeUseCase(repository: getIt()));

  // 5. Register BLoC
  getIt.registerFactory(
    () => SettingsBloc(getThemeUsecase: getIt(), saveThemeUsecase: getIt()),
  );
}
