import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/sevices/assets.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/presentation/bloc/account/groups_bloc/groups_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/highlight_bloc/highlight_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/pages/account/explore_groups_page.dart';
import 'package:prism/features/account/presentation/pages/account/personal_account_page.dart';
import 'package:prism/features/account/presentation/pages/notification/notifications_page.dart';
import 'package:prism/features/account/presentation/widgets/statuses_section_widget.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _wrapWithListener(Widget child) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoggedoutAuthState) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.signin,
                ModalRoute.withName(AppRoutes.myApp),
              );
            } else if (state is FailedAuthState) {
              showCustomAboutDialog(
                context,
                AppLocalizations.of(context)!.error,
                state.failure.message,
                null,
                true,
              );
            }
          },
        ),
        BlocListener<PAccountBloc, PAccountState>(
          listener: (context, state) {
            if (state is PAccountDeletedState) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.signin,
                ModalRoute.withName(AppRoutes.myApp),
              );
            } else if (state is FailedPAccountState) {
              showCustomAboutDialog(
                context,
                AppLocalizations.of(context)!.error,
                state.failure.message,
                null,
                true,
              );
            }
          },
        ),
      ],
      child: child,
    );
  }

  AppBar _buildAppBar() {
    switch (_selectedIndex) {
      case 4:
        return _profileAppBar();
      default:
        return _defaultAppBar();
    }
  }

  AppBar _profileAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: BlocBuilder<PAccountBloc, PAccountState>(
        builder: (context, state) {
          if (state is LoadedPAccountState) {
            return Text(
              state.personalAccount.fullName,
              style: Theme.of(context).textTheme.titleLarge,
            );
          }
          final pAccount = context.read<PAccountBloc>().pAccount;
          if (pAccount != null) {
            return Text(
              pAccount.fullName,
              style: Theme.of(context).textTheme.titleLarge,
            );
          }
          return SizedBox();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add_box_outlined),
          tooltip: AppLocalizations.of(context)!.add,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.archivedStatuses).then((
              addedNewHighlight,
            ) {
              if (mounted && addedNewHighlight is bool && addedNewHighlight) {
                context.read<HighlightBloc>().add(GetHighlights());
              }
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _showSettingsBottomSheet(context);
          },
        ),
      ],
    );
  }

  AppBar _defaultAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_outlined)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 32),
              Image.asset(Assets.walkThrough1, height: 46),
              Text(
                AppLocalizations.of(context)!.prism,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chat_bubble_outline),
              ),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _showSettingsBottomSheet(context);
                },
              ),
            ],
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
            ListTile(
              leading: Icon(Icons.co_present_rounded),
              title: Text(AppLocalizations.of(context)!.accountSettings),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.accountSettings);
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text(
                AppLocalizations.of(context)?.myOwnedGroups ?? 'Owned Groups',
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.myFollowedGroups,
                  arguments: {
                    'trigger': (BuildContext context) {
                      context.read<GroupsBloc>().add(GetOwnedGroupsEvent());
                    },
                    'title': AppLocalizations.of(context)?.myOwnedGroups,
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.groups_2),
              title: Text(
                AppLocalizations.of(context)?.myFollowedGroups ??
                    'Followed Groups',
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.myFollowedGroups,
                  arguments: {
                    'trigger': (BuildContext context) {
                      context.read<GroupsBloc>().add(GetFollowedGroupsEvent());
                    },
                    'title': AppLocalizations.of(context)?.myFollowedGroups,
                    'applyJoin': true,
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomNavBar() {
    final icons = [
      Icons.home,
      Icons.search,
      Icons.add_box_outlined,
      Icons.notifications,
      Icons.account_circle,
    ];

    return BlocBuilder<PAccountBloc, PAccountState>(
      builder: (context, state) {
        String? picUrl =
            state is LoadedPAccountState
                ? state.personalAccount.picUrl
                : context.read<PAccountBloc>().pAccount?.picUrl;
        bool hasPic = picUrl != null && picUrl.isNotEmpty;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            if (index == 4 && hasPic) {
              final addCircle = _selectedIndex == index;
              return GestureDetector(
                child: ProfilePicture(
                  link: picUrl,
                  radius: addCircle ? 18 : 16,
                  hasStatus: addCircle,
                ),
                onTap: () => _updatePage(index),
              );
            }
            return IconButton(
              icon: Icon(
                icons[index],
                color:
                    _selectedIndex == index
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                size: _selectedIndex == index ? 40 : 32,
              ),
              onPressed: () => _updatePage(index),
            );
          }),
        );
      },
    );
  }

  void _updatePage(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _getPersonalAccountPage() {
    return PersonalAccountPage();
  }

  Widget _getNotificationsPage() {
    return NotificationsPage();
  }

  Widget _buildPostsSection() {
    // TODO: RAFAT POSTS ADDED HERE as widget (if wanted to add a list view or single child scroll view then make no scroll physics and wrap parent widget 'column' with a 'single child scroll view')
    return Center(child: Text(AppLocalizations.of(context)!.postsSection));
  }

  Widget _buildHomePage() {
    return Column(
      children: [
        StatusesSectionWidget(),
        Expanded(child: _buildPostsSection()),
      ],
    );
  }

  Widget _buildSearchPage() {
    return Column(
      children: [
        TabBar(
          labelColor: Theme.of(context).colorScheme.secondary,
          automaticIndicatorColorAdjustment: true,
          dividerColor: Colors.transparent,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.explore),
            Tab(text: 'all'),
          ],
        ),
        Expanded(
          child: BlocProvider<GroupsBloc>(
            create: (context) => sl<GroupsBloc>(),
            child: TabBarView(
              controller: _tabController,
              children: [const ExploreGroupsPage(), Text('all')],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      children: [
        _buildHomePage(),
        _buildSearchPage(),
        Center(
          child: Text(
            AppLocalizations.of(context)!.add,
            style: TextStyle(fontSize: 32),
          ),
        ),
        _getNotificationsPage(),
        _getPersonalAccountPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _wrapWithListener(
      Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [Expanded(child: _buildPageView()), _buildCustomNavBar()],
        ),
      ),
    );
  }
}
