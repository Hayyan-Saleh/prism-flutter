import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/sevices/assets.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/pages/account/personal_account_page.dart';
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
    return BlocListener<AuthBloc, AuthState>(
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
            "Error",
            state.failure.message,
            null,
            true,
          );
        }
      },
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
              Text("Prism", style: Theme.of(context).textTheme.titleLarge),
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
          height: 200,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.settings),
                // TODO: Localize
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.settings);
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                // TODO: Localize
                title: Text('Edit Profile'),
                onTap: () {
                  context.read<PAccountBloc>().add(LoadRemotePAccountEvent());

                  Navigator.pop(context);

                  Navigator.pushNamed(
                    context,
                    AppRoutes.updateAccount,
                    arguments: true,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomNavBar() {
    return BlocBuilder<PAccountBloc, PAccountState>(
      builder: (context, state) {
        final List<IconData> icons = [
          Icons.home,
          Icons.search,
          Icons.add_box_outlined,
          Icons.video_call,
          Icons.account_circle,
        ];

        if (state is LoadedPAccountState) {
          if (state.personalAccount.picUrl != null &&
              state.personalAccount.picUrl != '') {
            final personalPic = ProfilePicture(
              link: state.personalAccount.picUrl!,
              radius: 16,
            );
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                if (index != icons.length - 1) {
                  return IconButton(
                    icon: Icon(
                      icons[index],
                      color:
                          _selectedIndex == index
                              ? Theme.of(context).colorScheme.secondary
                              : null,
                      size: _selectedIndex == index ? 40 : 32,
                    ),
                    onPressed: () {
                      _selectedIndex = index;
                      _pageController.animateToPage(
                        _selectedIndex,
                        duration: Duration(microseconds: 100),
                        curve: Curves.easeInOut,
                      );
                      setState(() {});
                    },
                  );
                } else {
                  return GestureDetector(
                    child: personalPic,
                    onTap: () {
                      _selectedIndex = index;
                      _pageController.animateToPage(
                        _selectedIndex,
                        duration: Duration(microseconds: 100),
                        curve: Curves.easeInOut,
                      );
                      setState(() {});
                    },
                  );
                }
              }),
            );
          }
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                icons[index],
                color:
                    _selectedIndex == index
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                size: _selectedIndex == index ? 40 : 32,
              ),
              onPressed: () {
                _selectedIndex = index;
                _pageController.animateToPage(
                  _selectedIndex,
                  duration: Duration(microseconds: 100),
                  curve: Curves.easeInOut,
                );
                setState(() {});
              },
            );
          }),
        );
      },
    );
  }

  Widget _getPersonalAccountPage() {
    context.read<PAccountBloc>().add(LoadRemotePAccountEvent());
    return PersonalAccountPage();
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      children: [
        Center(child: Text('Home', style: TextStyle(fontSize: 32))),
        Center(child: Text('Search', style: TextStyle(fontSize: 32))),
        Center(child: Text('Add', style: TextStyle(fontSize: 32))),
        Center(child: Text('Video', style: TextStyle(fontSize: 32))),
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
