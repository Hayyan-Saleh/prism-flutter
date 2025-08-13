import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:prism/core/network/api_client.dart';
import 'package:prism/core/network/live_stream_api_client.dart';
import 'package:prism/core/util/sevices/api_endpoints.dart';
import 'package:prism/core/util/sevices/token_service.dart';
import 'package:prism/features/account/data/data-sources/account_remote_data_source.dart';
import 'package:prism/features/account/data/data-sources/notification_remote_data_source.dart';
import 'package:prism/features/account/data/data-sources/personal_account_local_data_source.dart';
import 'package:prism/features/account/data/repository/account_repository_impl.dart';
import 'package:prism/features/account/data/repository/notification_repository_impl.dart';
import 'package:prism/features/account/domain/repository/account_repository.dart';
import 'package:prism/features/account/domain/repository/notification_repository.dart';
import 'package:prism/features/account/domain/use-cases/account/add_to_highlight_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/block_user_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/check_account_name_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/create_group_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/create_highlight_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/create_status_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/delete_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/delete_group_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/delete_highlight_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/delete_status_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/explore_groups_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_archived_statuses_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_blocked_accounts_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_detailed_highlight_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_followed_groups_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_followers_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_following_statuses_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_following_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_group_join_requests_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_group_members_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_highlights_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_local_personal_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_other_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_remote_personal_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_status_likers_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_statuses_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/toggle_group_membership_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/toggle_like_status_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/toggle_other_account_follow_use_case.dart';
import 'package:prism/features/account/domain/use-cases/account/unblock_user_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/update_group_member_role_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/update_group_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/update_highlight_cover_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/update_personal_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/notification/get_follow_requests_usecase.dart';
import 'package:prism/features/account/domain/use-cases/notification/get_join_requests_usecase.dart';
import 'package:prism/features/account/domain/use-cases/notification/respond_to_follow_request_usecase.dart';
import 'package:prism/features/account/domain/use-cases/notification/respond_to_join_request_usecase.dart';
import 'package:prism/features/account/presentation/bloc/account/follow_bloc/follow_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/groups_bloc/groups_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/join_group_bloc/join_group_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/other_account_bloc/other_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/account_name_bloc/account_name_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/update_group_member_role_bloc/update_group_member_role_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/users_bloc/accounts_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/highlight_bloc/highlight_bloc.dart';
import 'package:prism/features/account/presentation/bloc/like_bloc/like_bloc.dart';
import 'package:prism/features/account/presentation/bloc/notification/notification_bloc/notification_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/group_bloc/group_bloc.dart';
import 'package:prism/features/account/domain/use-cases/account/get_group_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_owned_groups_usecase.dart';
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
import 'package:prism/features/live-stream/data/data-sources/chat_remote_data_source.dart';
import 'package:prism/features/live-stream/data/data-sources/live_stream_local_data_source.dart';
import 'package:prism/features/live-stream/data/data-sources/live_stream_remote_data_source.dart';
import 'package:prism/features/live-stream/data/repository/chat_repository_impl.dart';
import 'package:prism/features/live-stream/data/repository/live_stream_repository_impl.dart';
import 'package:prism/features/live-stream/data/services/ffmpeg_service.dart';
import 'package:prism/features/live-stream/data/services/socket_io_service.dart';
import 'package:prism/features/live-stream/domain/repository/chat_repository.dart';
import 'package:prism/features/live-stream/domain/repository/live_stream_repository.dart';
import 'package:prism/features/live-stream/domain/use-cases/connect_to_chat_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/disconnect_from_chat_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/end_stream_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/get_active_streams_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/get_chat_messages_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/get_stream_ended_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/get_views_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/send_chat_message_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/start_stream_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/start_streaming_use_case.dart';
import 'package:prism/features/live-stream/domain/use-cases/stop_streaming_use_case.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/rtmp_bloc/rtmp_bloc.dart';
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
    ApiClient(baseUrl: ApiEndpoints.coreBaseUrl, httpClient: http.Client()),
  );

  sl.registerSingleton<LiveStreamApiClient>(
    LiveStreamApiClient(
      baseUrl: ApiEndpoints.liveStreamBaseUrl,
      httpClient: http.Client(),
    ),
  );

  sl.registerLazySingleton<FfmpegService>(() => FfmpegService());

  sl.registerLazySingleton<SocketIOService>(() => SocketIOService());
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
      getArchivedStatusesUsecase: sl(),
    ),
  );
  sl.registerFactoryParam<LikeBloc, bool, int>(
    (isLiked, likesCount) => LikeBloc(
      toggleLikeStatusUseCase: sl(),
      isLiked: isLiked,
      likesCount: likesCount,
    ),
  );
  sl.registerFactory(
    () =>
        OAccountBloc(blockUser: sl(), getOtherAccount: sl(), unblockUser: sl()),
  );

  sl.registerFactory(
    () => AccountsBloc(
      getFollowers: sl(),
      getFollowing: sl(),
      getBlocked: sl(),
      getStatusLikers: sl(),
      getGroupMembers: sl(),
    ),
  );

  sl.registerFactory(() => FollowBloc(toggleOAccountFollow: sl()));
  sl.registerFactory(
    () => NotificationBloc(
      getFollowRequestsUseCase: sl(),
      respondToFollowRequestUseCase: sl(),
      getJoinRequestsUseCase: sl(),
      respondToJoinRequestUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => HighlightBloc(
      createHighlightUseCase: sl(),
      getHighlightsUsecase: sl(),
      getDetailedHighlightUsecase: sl(),
      deleteHighlightUseCase: sl(),
      updateHighlightCoverUseCase: sl(),
      addToHighlightUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => GroupBloc(
      createGroupUseCase: sl(),
      getGroupUseCase: sl(),
      updateGroupUseCase: sl(),
      deleteGroupUseCase: sl(),
      getGroupJoinRequestsUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => GroupsBloc(
      getOwnedGroupsUseCase: sl(),
      getFollowedGroupsUseCase: sl(),
      exploreGroupsUseCase: sl(),
    ),
  );
  sl.registerFactory(() => JoinGroupBloc(toggleGroupMembershipUseCase: sl()));

  sl.registerFactory(
    () => UpdateGroupMemberRoleBloc(updateGroupMemberRoleUseCase: sl()),
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
  sl.registerLazySingleton(() => GetArchivedStatusesUsecase(repository: sl()));
  sl.registerLazySingleton(() => ToggleLikeStatusUseCase(repository: sl()));

  sl.registerLazySingleton(() => GetFollowersUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetFollowingUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetBlockedAccountsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOtherAccountUsecase(repository: sl()));
  sl.registerLazySingleton(() => ToggleOAccountFollowUseCase(repository: sl()));
  sl.registerLazySingleton(() => BlockUserUsecase(repository: sl()));
  sl.registerLazySingleton(() => UnblockUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetFollowRequestsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetJoinRequestsUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => RespondToFollowRequestUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => RespondToJoinRequestUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetStatusLikersUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetGroupMembersUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateHighlightUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetHighlightsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetDetailedHighlightUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteHighlightUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateHighlightCoverUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddToHighlightUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateGroupUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetGroupUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateGroupUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteGroupUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetGroupJoinRequestsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetOwnedGroupsUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => ToggleGroupMembershipUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => UpdateGroupMemberRoleUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => GetFollowedGroupsUseCase(repository: sl()));
  sl.registerLazySingleton(() => ExploreGroupsUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      authLDS: sl(),
      personalAccLDS: sl(),
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

  // ! live-stream

  // Bloc
  sl.registerFactory(
    () => LiveStreamBloc(
      getActiveStreamsUseCase: sl(),
      startStreamUseCase: sl(),
      endStreamUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ChatBloc(
      connectToChatUseCase: sl(),
      disconnectFromChatUseCase: sl(),
      getChatMessagesUseCase: sl(),
      getViewsUseCase: sl(),
      sendChatMessageUseCase: sl(),
      getStreamEndedUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => RtmpBloc(startStreamingUseCase: sl(), stopStreamingUseCase: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetActiveStreamsUseCase(sl()));
  sl.registerLazySingleton(() => StartStreamUseCase(sl()));
  sl.registerLazySingleton(() => EndStreamUseCase(sl()));

  sl.registerLazySingleton(() => ConnectToChatUseCase(sl()));
  sl.registerLazySingleton(() => DisconnectFromChatUseCase(sl()));
  sl.registerLazySingleton(() => GetChatMessagesUseCase(sl()));
  sl.registerLazySingleton(() => GetViewsUseCase(sl()));
  sl.registerLazySingleton(() => SendChatMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetStreamEndedUseCase(sl()));

  sl.registerLazySingleton(() => StartStreamingUseCase(sl()));
  sl.registerLazySingleton(() => StopStreamingUseCase(sl()));

  // Repository
  sl.registerLazySingleton<LiveStreamRepository>(
    () =>
        LiveStreamRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LiveStreamLocalDataSource>(
    () => LiveStreamLocalDataSourceImpl(ffmpegService: sl()),
  );
  sl.registerLazySingleton<LiveStreamRemoteDataSource>(
    () => LiveStreamRemoteDataSourceImpl(apiClient: sl(), tokenService: sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(socketIOService: sl()),
  );
}
