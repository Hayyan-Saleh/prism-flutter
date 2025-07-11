import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/sevices/assets.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/pages/account/personal_account_page.dart';
import 'package:prism/features/account/presentation/widgets/statuses_section_widget.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

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
        return Container(
          height: 250,
          padding: EdgeInsets.all(16),
          child: Column(
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
                leading: Icon(Icons.person),
                title: Text(AppLocalizations.of(context)!.editProfile),
                onTap: () {
                  context.read<PAccountBloc>().add(LoadRemotePAccountEvent());

                  Navigator.pop(context);

                  Navigator.pushNamed(
                    context,
                    AppRoutes.updateAccount,
                    arguments: {
                      'personalAccount': context.read<PAccountBloc>().pAccount,
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  AppLocalizations.of(context)!.deleteAccount,
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  showCustomAboutDialog(
                    context,
                    AppLocalizations.of(context)!.deleteAccount,
                    AppLocalizations.of(context)!.deleteAccountConfirmation,
                    [
                      AppButton(
                        child: Text(AppLocalizations.of(context)!.ok),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          Navigator.pushNamed(context, AppRoutes.deleteAccount);
                        },
                      ),
                      AppButton(
                        bgColor: Colors.green,
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                    true,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ! hello?
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
              return GestureDetector(
                child: ProfilePicture(link: picUrl, radius: 16),
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

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      children: [
        _buildHomePage(),
        Center(
          child: Text(
            AppLocalizations.of(context)!.search,
            style: TextStyle(fontSize: 32),
          ),
        ),
        Center(
          child: Text(
            AppLocalizations.of(context)!.add,
            style: TextStyle(fontSize: 32),
          ),
        ),
        Center(
          child: Text(
            AppLocalizations.of(context)!.video,
            style: TextStyle(fontSize: 32),
          ),
        ),
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
