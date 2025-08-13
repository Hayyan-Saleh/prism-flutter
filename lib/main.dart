import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_entity.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/main/group_entity.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/follow_bloc/follow_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/group_bloc/group_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/groups_bloc/groups_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/join_group_bloc/join_group_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/other_account_bloc/other_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/account_name_bloc/account_name_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/update_group_member_role_bloc/update_group_member_role_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/users_bloc/accounts_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/highlight_bloc/highlight_bloc.dart';
import 'package:prism/features/account/presentation/bloc/notification/notification_bloc/notification_bloc.dart';
import 'package:prism/features/account/presentation/pages/account/account_middle_point_page.dart';
import 'package:prism/features/account/presentation/pages/account/account_settings_page.dart';
import 'package:prism/features/account/presentation/pages/account/accounts_page.dart';
import 'package:prism/features/account/presentation/pages/account/add_status_page.dart';
import 'package:prism/features/account/presentation/pages/account/block_account_page.dart';
import 'package:prism/features/account/presentation/pages/account/blocked_accounts_page.dart';
import 'package:prism/features/account/presentation/pages/account/create_group_page.dart';
import 'package:prism/features/account/presentation/pages/account/delete_account_page.dart';
import 'package:prism/features/account/presentation/pages/account/delete_group_page.dart';
import 'package:prism/features/account/presentation/pages/account/following_statuses_page.dart';
import 'package:prism/features/account/presentation/pages/account/group_join_requests_page.dart';
import 'package:prism/features/account/presentation/pages/account/group_page.dart';
import 'package:prism/features/account/presentation/pages/account/other_account_page.dart';
import 'package:prism/features/account/presentation/pages/account/groups_page.dart';
import 'package:prism/features/account/presentation/pages/account/show_highlights_page.dart';
import 'package:prism/features/account/presentation/pages/account/show_status_page.dart';
import 'package:prism/features/account/presentation/pages/account/update_account_page.dart';
import 'package:prism/features/account/presentation/pages/account/archived_statuses_page.dart';
import 'package:prism/features/account/presentation/pages/account/select_highlight_page.dart';
import 'package:prism/features/account/presentation/pages/account/update_highlight_cover_page.dart';
import 'package:prism/features/account/presentation/pages/account/update_group_page.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';
import 'package:prism/features/live-stream/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_event.dart';
import 'package:prism/features/live-stream/presentation/bloc/rtmp_bloc/rtmp_bloc.dart';
import 'package:prism/features/live-stream/presentation/pages/create_live_stream_page.dart';
import 'package:prism/features/live-stream/presentation/pages/live_stream_page.dart';
import 'package:prism/features/live-stream/presentation/pages/live_streams_page.dart';
import 'package:camera/camera.dart';

import 'package:prism/features/live-stream/presentation/pages/my_stream_page.dart';
import 'package:prism/features/preferences/presentation/bloc/preferences_bloc/preferences_bloc.dart';
import 'package:prism/features/preferences/presentation/pages/walk_through_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/pages/settings_page.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:prism/features/auth/presentation/pages/auth_middle_point.dart';
import 'package:prism/features/auth/presentation/pages/change_email_page.dart';
import 'package:prism/features/auth/presentation/pages/change_password_page.dart';
import 'package:prism/features/auth/presentation/pages/reset_password_page.dart';
import 'package:prism/features/auth/presentation/pages/signin_page.dart';
import 'package:prism/features/auth/presentation/pages/signup_page.dart';
import 'package:prism/features/auth/presentation/pages/verification_page.dart';
import 'package:prism/features/preferences/domain/entities/preferences_entity.dart';
import 'package:prism/features/preferences/presentation/pages/preferences_middle_point_page.dart';
import 'package:prism/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PreferencesBloc>(
          create:
              (context) =>
                  sl<PreferencesBloc>()
                    ..add(DefinePreferencesCurrentStateEvent()),
        ),
        BlocProvider<AuthBloc>(
          create:
              (context) => sl<AuthBloc>()..add(DefineAuthCurrentStateEvent()),
        ),
        BlocProvider<PAccountBloc>(
          create:
              (context) =>
                  sl<PAccountBloc>()..add(DefinePAccountCurrentStateEvent()),
        ),
        BlocProvider<AccountNameBloc>(
          create: (context) => sl<AccountNameBloc>(),
        ),
        BlocProvider<OAccountBloc>(create: (context) => sl<OAccountBloc>()),
        BlocProvider<StatusBloc>(create: (context) => sl<StatusBloc>()),
        BlocProvider<HighlightBloc>(create: (context) => sl<HighlightBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');

  void _changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _assignPreferences(PreferencesEntity preferences) {
    _locale = preferences.appLocal.locale;
    _themeMode = preferences.appTheme.themeMode;
  }

  Map<String, WidgetBuilder> _getRoutes() {
    return {
      AppRoutes.prefMiddlePoint:
          (context) => PreferencesMiddlePointPage(
            onLocaleChanged: _changeLocale,
            onThemeChanged: _changeThemeMode,
          ),
      AppRoutes.walkthrough:
          (context) => WalkThroughPage(
            onLocaleChanged: _changeLocale,
            onThemeChanged: _changeThemeMode,
          ),
      AppRoutes.authMiddlePoint: (context) => AuthMiddlePointPage(),
      AppRoutes.signin: (context) => SignInPage(),
      AppRoutes.signup: (context) => SignUpPage(),
      AppRoutes.verification: (context) => VerificationPage(),
      AppRoutes.reset: (context) => ResetPasswordPage(),
      AppRoutes.changeEmail: (context) => ChangeEmailPage(),
      AppRoutes.changePassword: (context) => ChangePasswordPage(),
      AppRoutes.accMiddlePoint: (context) => AccountMiddlePointPage(),
      AppRoutes.updateAccount: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final personalAccount =
            args?['personalAccount'] as PersonalAccountEntity?;
        return UpdateAccountPage(pAccount: personalAccount);
      },
      AppRoutes.home: (context) => HomePage(),
      AppRoutes.deleteAccount: (context) => DeleteAccountPage(),
      AppRoutes.blockedAccounts:
          (context) => BlocProvider<AccountsBloc>(
            create: (context) => sl<AccountsBloc>(),
            child: BlockedAccountsPage(),
          ),
      AppRoutes.blocAccPage: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final fullName = args?['fullName'] as String?;
        final otherAccountId = args?['otherAccountId'] as int?;
        return BlocProvider<OAccountBloc>(
          create: (context) => sl<OAccountBloc>(),
          child: BlockAccountPage(
            fullName: fullName ?? '',
            otherAccountId: otherAccountId ?? 0,
          ),
        );
      },
      AppRoutes.otherAccPage: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final personalAccountId = args?['personalAccountId'] as int?;
        final otherAccountId = args?['otherAccountId'] as int?;
        return MultiBlocProvider(
          providers: [
            BlocProvider<OAccountBloc>(create: (context) => sl<OAccountBloc>()),
            BlocProvider<FollowBloc>(create: (context) => sl<FollowBloc>()),
            BlocProvider<HighlightBloc>(
              create: (context) => sl<HighlightBloc>(),
            ),
          ],
          child: OtherAccountPage(
            otherAccountId: otherAccountId ?? 0,
            personalAccountId: personalAccountId ?? 0,
          ),
        );
      },
      AppRoutes.accounts: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final appBarTitle = args?['appBarTitle'] as String;
        final triggerEvent = args?['triggerEvent'] as Function(BuildContext);
        final isGroupMembersPage =
            args?['isGroupMembersPage'] as bool? ?? false;
        final updateGroupRole = args?['updateGroupRole'] as bool? ?? false;
        final groupId = args?['groupId'] as int? ?? 0;
        return MultiBlocProvider(
          providers: [
            BlocProvider<AccountsBloc>(create: (context) => sl<AccountsBloc>()),
            BlocProvider<UpdateGroupMemberRoleBloc>(
              create: (context) => sl<UpdateGroupMemberRoleBloc>(),
            ),
          ],
          child: AccountsPage(
            appBarTitle: appBarTitle,
            triggerEvent: triggerEvent,
            isGroupMembersPage: isGroupMembersPage,
            updateGroupRole: updateGroupRole,
            groupId: groupId,
          ),
        );
      },
      AppRoutes.followingStatusesPage: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final initialUserIndex = args?['initialUserIndex'] as int?;
        final userIds = args?['userIds'] as List<int>?;
        return FollowingStatusesPage(
          initialUserIndex: initialUserIndex ?? 0,
          userIds: userIds ?? [],
        );
      },
      AppRoutes.showStatusPage: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final userId = args?['userId'] as int?;
        final personalStatuses = args?['personalStatuses'] as bool? ?? false;

        final followStatus = args?['followStatus'] as FollowStatus?;
        return MultiBlocProvider(
          providers: [
            BlocProvider<StatusBloc>(create: (context) => sl<StatusBloc>()),
            BlocProvider<AccountsBloc>(create: (context) => sl<AccountsBloc>()),
          ],
          child: ShowStatusPage(
            userId: userId ?? 0,
            personalStatuses: personalStatuses,
            followStatus: followStatus ?? FollowStatus.following,
          ),
        );
      },

      AppRoutes.addStatusPage:
          (context) => BlocProvider<StatusBloc>(
            create: (context) => sl<StatusBloc>(),
            child: AddStatusPage(),
          ),
      AppRoutes.archivedStatuses: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final isAddToHighlightMode =
            args?['isAddToHighlightMode'] as bool? ?? false;
        return BlocProvider<StatusBloc>(
          create: (context) => sl<StatusBloc>(),
          child: ArchivedStatusesPage(
            isAddToHighlightMode: isAddToHighlightMode,
          ),
        );
      },
      AppRoutes.showHighlights: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final initialHighlightIndex = args?['initialHighlightIndex'] as int?;
        final highlightIds = args?['highlightIds'] as List<int>?;
        final isMyHighlight = args?['isMyHighlight'] as bool?;
        final account = args?['account'] as AccountEntity?;

        if (account == null ||
            highlightIds == null ||
            initialHighlightIndex == null) {
          return const Scaffold(
            body: Center(
              child: Text('Error: Missing arguments for ShowHighlightsPage.'),
            ),
          );
        }

        return ShowHighlightsPage(
          initialHighlightIndex: initialHighlightIndex,
          highlightIds: highlightIds,
          isMyHighlight: isMyHighlight ?? true,
          account: account,
        );
      },
      AppRoutes.selectHighlight: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final statusId = args?['statusId'] as int?;
        return SelectHighlightPage(statusId: statusId ?? 0);
      },
      AppRoutes.updateHighlightCover: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final highlightId = args?['highlightId'] as int?;
        final coverUrl = args?['coverUrl'] as String?;
        return BlocProvider<HighlightBloc>(
          create: (context) => sl<HighlightBloc>(),
          child: UpdateHighlightCoverPage(
            highlightId: highlightId ?? 0,
            coverUrl: coverUrl,
          ),
        );
      },
      AppRoutes.createGroup:
          (context) => BlocProvider<GroupBloc>(
            create: (context) => sl<GroupBloc>(),
            child: CreateGroupPage(),
          ),
      AppRoutes.groupPage: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final groupId = args?['groupId'] as int?;
        return MultiBlocProvider(
          providers: [
            BlocProvider<GroupBloc>(create: (context) => sl<GroupBloc>()),
            BlocProvider<JoinGroupBloc>(
              create: (context) => sl<JoinGroupBloc>(),
            ),
          ],
          child: GroupPage(groupId: groupId ?? 0),
        );
      },
      AppRoutes.myFollowedGroups: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final trigger =
            args?['trigger'] as void Function(BuildContext context)? ??
            (context) {};
        final title =
            args?['title'] as String? ??
            AppLocalizations.of(context)?.myGroups ??
            '';
        final applyJoin = args?['applyJoin'] as bool? ?? false;
        return BlocProvider<GroupsBloc>(
          create: (context) => sl<GroupsBloc>(),
          child: GroupsPage(
            title: title,
            trigger: trigger,
            applyJoin: applyJoin,
          ),
        );
      },
      AppRoutes.updateGroup: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final group = args?['group'] as GroupEntity?;
        final groupId = args?['groupId'] as int?;
        return BlocProvider<GroupBloc>(
          create: (context) => sl<GroupBloc>(),
          child: UpdateGroupPage(group: group, groupId: groupId),
        );
      },
      AppRoutes.deleteGroup: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final groupName = args?['groupName'] as String? ?? '';
        final groupId = args?['groupId'] as int? ?? 0;
        return BlocProvider<GroupBloc>(
          create: (context) => sl<GroupBloc>(),
          child: DeleteGroupPage(groupName: groupName, groupId: groupId),
        );
      },
      AppRoutes.groupJoinRequests: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final groupId = args?['groupId'] as int? ?? 0;
        return MultiBlocProvider(
          providers: [
            BlocProvider<GroupBloc>(create: (context) => sl<GroupBloc>()),
            BlocProvider(create: (context) => sl<NotificationBloc>()),
          ],
          child: GroupJoinRequestsPage(groupId: groupId),
        );
      },
      AppRoutes.liveStream: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final stream = args?['stream'] as LiveStreamEntity;
        return MultiBlocProvider(
          providers: [
            BlocProvider<LiveStreamBloc>(
              create: (context) => sl<LiveStreamBloc>(),
            ),
            BlocProvider<ChatBloc>(create: (context) => sl<ChatBloc>()),
          ],
          child: LiveStreamPage(stream: stream),
        );
      },
      AppRoutes.liveStreams:
          (context) => BlocProvider<LiveStreamBloc>(
            create:
                (context) =>
                    sl<LiveStreamBloc>()
                      ..add(GetActiveStreamsEvent(page: 1, limit: 10)),
            child: LiveStreamsPage(),
          ),
      AppRoutes.createLiveStream:
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider<LiveStreamBloc>(
                create: (context) => sl<LiveStreamBloc>(),
              ),
              BlocProvider<RtmpBloc>(create: (context) => sl<RtmpBloc>()),
            ],
            child: const CreateLiveStreamPage(),
          ),
      AppRoutes.myLiveStream: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        final stream = args['stream'] as LiveStreamEntity;
        final cameraDescription =
            args['cameraDescription'] as CameraDescription;
        final enableAudio = args['enableAudio'] as bool;
        return MultiBlocProvider(
          providers: [
            BlocProvider<LiveStreamBloc>.value(value: sl<LiveStreamBloc>()),
            BlocProvider<RtmpBloc>(create: (context) => sl<RtmpBloc>()),
            BlocProvider<ChatBloc>(create: (context) => sl<ChatBloc>()),
          ],
          child: MyStreamPage(
            stream: stream,
            cameraDescription: cameraDescription,
            enableAudio: enableAudio,
          ),
        );
      },
      AppRoutes.myApp: (context) => MyApp(),
      AppRoutes.accountSettings: (context) => AccountSettingsPage(),
      AppRoutes.settings:
          (context) => SettingsPage(
            onLocaleChanged: _changeLocale,
            onThemeChanged: _changeThemeMode,
          ),
    }.map(
      (key, value) =>
          MapEntry(key, (context) => fixDirection(child: value(context))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      builder: (context, state) {
        if (state is LoadedPreferencesState) {
          _assignPreferences(state.preferences);
        } else if (state is DoneStorePreferencesState) {
          _assignPreferences(state.preferences);
        }
        return MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          locale: _locale,
          debugShowCheckedModeBanner: false,
          theme: FlexThemeData.light(
            scheme: FlexScheme.green,
            primary: Colors.grey[100],
            onPrimary: Colors.grey[900],
            useMaterial3: true,
            fontFamily: 'sans-serif',
          ).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Theme.of(context).colorScheme.secondary,
              selectionColor: Theme.of(
                context,
              ).colorScheme.secondary.withAlpha(200),
              selectionHandleColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.greenM3,
            primary: const Color.fromARGB(255, 24, 24, 24),
            onPrimary: Colors.grey[100],
            secondary: const Color.fromARGB(255, 10, 90, 10),
            primaryLightRef: Colors.grey[100],
            useMaterial3: true,
            fontFamily: 'sans-serif',
          ).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Theme.of(context).colorScheme.secondary,
              selectionColor: Theme.of(
                context,
              ).colorScheme.secondary.withAlpha(200),
              selectionHandleColor: Theme.of(context).colorScheme.secondary,
            ),
          ),

          themeAnimationCurve: Curves.fastOutSlowIn,
          themeAnimationDuration: Duration(seconds: 2),
          themeMode: _themeMode,
          routes: _getRoutes(),
          initialRoute: AppRoutes.prefMiddlePoint,
        );
      },
    );
  }
}
