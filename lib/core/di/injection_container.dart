import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:prism/core/network/api_client.dart';
import 'package:prism/core/util/sevices/api_endpoints.dart';
import 'package:prism/core/util/sevices/token_service.dart';
import 'package:prism/features/account/data/data-sources/account_remote_data_source.dart';
import 'package:prism/features/account/data/data-sources/notification_remote_data_source.dart';
import 'package:prism/features/account/data/data-sources/personal_account_local_data_source.dart';
import 'package:prism/features/account/data/repository/account_repository_impl.dart';
import 'package:prism/features/account/data/repository/notification_repository_impl.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';
import 'package:prism/features/account/domain/repository/notification_repository.dart';
import 'package:prism/features/account/domain/use-cases/account/block_user_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/check_account_name_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/create_status_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/delete_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/delete_status_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_followers_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_following_statuses_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_following_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_local_personal_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_other_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_remote_personal_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_statuses_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/toggle_other_account_follow_use_case.dart';
import 'package:prism/features/account/domain/use-cases/account/unblock_user_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/update_personal_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/notification/get_follow_requests_usecase.dart';
import 'package:prism/features/account/domain/use-cases/notification/respond_to_follow_request_usecase.dart';
import 'package:prism/features/account/presentation/bloc/account/follow_bloc/follow_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/other_account_bloc/other_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/account_name_bloc/account_name_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/users_bloc/accounts_bloc.dart';
import 'package:prism/features/account/presentation/bloc/notification/notification_bloc.dart';
import 'package:prism/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prism/features/auth/data/datasources/google_auth_datasource.dart';
import 'package:prism/features/auth/data/datasources/user_local_data_source.dart';
import 'package:prism/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prism/features/auth/domain/repositories/auth_repository.dart';
import 'package:prism/features/auth/domain/usecases/change_password_use_case.dart';
import 'package:prism/features/auth/domain/usecases/delete_token_use_case.dart';
import 'package:prism/features/auth/domain/usecases/google_sign_in_use_case.dart';
import 'package:prism/features/auth/domain/usecases/load_token_use_case.dart';
import 'package:prism/features/auth/domain/usecases/load_user_use_case.dart';
import 'package:prism/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:prism/features/auth/domain/usecases/logout_use_case.dart';
import 'package:prism/features/auth/domain/usecases/register_user_use_case.dart';
import 'package:prism/features/auth/domain/usecases/request_change_email_code_usecase.dart';
import 'package:prism/features/auth/domain/usecases/send_email_code_use_case.dart';
import 'package:prism/features/auth/domain/usecases/store_token_use_case.dart';
import 'package:prism/features/auth/domain/usecases/verify_change_email_code_usecase.dart';
import 'package:prism/features/auth/domain/usecases/verify_email_use_case.dart';
import 'package:prism/features/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:prism/features/preferences/data/data_soucres/preferences_local_data_source.dart';
import 'package:prism/features/preferences/data/repositories/preferences_repository_impl.dart';
import 'package:prism/features/preferences/domain/repositories/preferences_repository.dart';
import 'package:prism/features/preferences/domain/use_cases/load_preferences_use_case.dart';
import 'package:prism/features/preferences/domain/use_cases/store_preferences_use_case.dart';
import 'package:prism/features/preferences/presentation/bloc/preferences_bloc/preferences_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //? extras

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<TokenService>(
    () =>
        TokenServiceImpl(loadToken: sl(), deleteToken: sl(), storeToken: sl()),
  );
  sl.registerSingleton<ApiClient>(
    ApiClient(baseUrl: ApiEndpoints.baseUrl, httpClient: http.Client()),
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
  sl.registerLazySingleton(() => LoadToken(sl()));
  sl.registerLazySingleton(() => DeleteToken(sl()));
  sl.registerLazySingleton(() => StoreToken(sl()));

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

  // ! account

  // Bloc
  sl.registerFactory(
    () => PAccountBloc(
      getLocalPersonalAccount: sl(),
      getRemotePersonalAccount: sl(),
      updatePersonalAccount: sl(),
      deleteAccount: sl(),
    ),
  );

  sl.registerFactory(() => AccountNameBloc(checkAccountName: sl()));

  sl.registerFactory(
    () => StatusBloc(
      createStatusUseCase: sl(),
      deleteStatusUseCase: sl(),
      getStatusesUseCase: sl(),
      getFollowingStatuses: sl(),
    ),
  );
  sl.registerFactory(
    () =>
        OAccountBloc(blockUser: sl(), getOtherAccount: sl(), unblockUser: sl()),
  );

  sl.registerFactory(
    () => AccountsBloc(getFollowers: sl(), getFollowing: sl()),
  );

  sl.registerFactory(() => FollowBloc(toggleOAccountFollow: sl()));
  sl.registerFactory(
    () => NotificationBloc(
      getFollowRequestsUseCase: sl(),
      respondToFollowRequestUseCase: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(
    () => GetLocalPersonalAccountUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetRemotePersonalAccountUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => CheckAccountNameUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => UpdatePersonalAccountUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => DeleteAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateStatusUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteStatusUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetStatusesUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetFollowingStatusesUsecase(repository: sl()));

  sl.registerLazySingleton(() => GetFollowersUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetFollowingUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetOtherAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => ToggleOAccountFollowUseCase(repository: sl()));
  sl.registerLazySingleton(() => BlockUserUsecase(repository: sl()));
  sl.registerLazySingleton(() => UnblockUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetFollowRequestsUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => RespondToFollowRequestUseCase(repository: sl()),
  );
  // Repository
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      loadUser: sl(),
      tokenService: sl(),
    ),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () =>
        NotificationRepositoryImpl(remoteDataSource: sl(), tokenService: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PersonalAccountLocalDataSource>(
    () => PersonalAccountLocalDataSourceImpl(prefs: prefs),
  );
  sl.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(apiClient: sl()),
  );
}
