import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:realmo/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:realmo/features/auth/data/datasources/google_auth_datasource.dart';
import 'package:realmo/features/auth/data/datasources/user_local_data_source.dart';
import 'package:realmo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:realmo/features/auth/domain/repositories/auth_repository.dart';
import 'package:realmo/features/auth/domain/usecases/change_password_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/google_sign_in_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/load_user_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/logout_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/register_user_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/request_change_email_code_usecase.dart';
import 'package:realmo/features/auth/domain/usecases/send_email_code_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/verify_change_email_code_usecase.dart';
import 'package:realmo/features/auth/domain/usecases/verify_email_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:realmo/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:realmo/features/preferences/data/data_soucres/preferences_local_data_source.dart';
import 'package:realmo/features/preferences/data/repositories/preferences_repository_impl.dart';
import 'package:realmo/features/preferences/domain/repositories/preferences_repository.dart';
import 'package:realmo/features/preferences/domain/use_cases/load_preferences_use_case.dart';
import 'package:realmo/features/preferences/domain/use_cases/store_preferences_use_case.dart';
import 'package:realmo/features/preferences/presentation/bloc/preferences_bloc/preferences_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //? extras

  // ! auth
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // ! preferences

  // Bloc
  sl.registerFactory(
    () => PreferencesBloc(
      storePreferencesUseCase: sl(),
      loadPreferencesUseCase: sl(),
    ),
  );

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

  // ! auth

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      changePassword: sl(),
      googleLogin: sl(),
      loadUser: sl(),
      logout: sl(),
      passwordLogin: sl(),
      registerUser: sl(),
      sendChangeEmailCode: sl(),
      sendEmailCode: sl(),
      verifyChangeEmailCode: sl(),
      verifyEmail: sl(),
      verifyResetCode: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => ChangePasswordUseCase(repository: sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoadUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => RequestChangeEmailCodeUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => SendEmailCodeUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => VerifyChangeEmailCodeUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => VerifyEmailUseCase(repository: sl()));
  sl.registerLazySingleton(() => VerifyResetCodeUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      googleAuth: sl(),
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(secureStorage: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(googleAuthDatasource: sl()),
  );
  sl.registerLazySingleton<GoogleAuthDatasource>(() => GoogleAuthDatasource());
}
