import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/features/account/presentation/bloc/account/groups_bloc/groups_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/core/localization/l10n/app_localizations.dart';
import 'package:prism/features/account/presentation/bloc/post/post_bloc/post_bloc.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.accountSettings),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Account',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 2,
            children: [
              _buildCard(
                context,
                Colors.blue[100]!,
                Icons.person,
                AppLocalizations.of(context)!.editProfile,
                () {
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
              _buildCard(
                context,
                Colors.pink[100]!,
                Icons.block,
                AppLocalizations.of(context)!.blockedAccounts,
                () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.blockedAccounts);
                },
              ),
              _buildCard(
                context,
                Colors.amber[100]!,
                Icons.archive,
                AppLocalizations.of(context)!.archivedStatuses,
                () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(
                    AppRoutes.archivedStatuses,
                    arguments: {'isAddToHighlightMode': true},
                  );
                },
              ),
              _buildCard(
                context,
                Colors.amber[100]!,
                Icons.bookmark,
                AppLocalizations.of(context)!.savedPosts,
                () async {
                  final navigator = Navigator.of(context, rootNavigator: true);
                  final pAccount = context.read<PAccountBloc>().pAccount;
                  final postBloc = context.read<PostBloc>();
                  Navigator.pop(context);
                  await navigator.pushNamed(AppRoutes.savedPostsPage);
                  if (pAccount != null) {
                    postBloc.add(
                      LoadPersonalPosts(userId: pAccount.id, pageNum: 1),
                    );
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Groups',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 2,
            children: [
              _buildCard(
                context,
                Colors.lightGreen[200]!,
                Icons.group_add,
                AppLocalizations.of(context)!.createGroup,
                () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(AppRoutes.createGroup);
                },
              ),
              _buildCard(
                context,
                Colors.green[200]!,
                Icons.group,
                AppLocalizations.of(context)?.myOwnedGroups ?? 'Owned Groups',
                () {
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
              _buildCard(
                context,
                Colors.green[100]!,
                Icons.groups_2,
                AppLocalizations.of(context)?.myFollowedGroups ??
                    'Followed Groups',
                () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.myFollowedGroups,
                    arguments: {
                      'trigger': (BuildContext context) {
                        context.read<GroupsBloc>().add(
                          GetFollowedGroupsEvent(),
                        );
                      },
                      'title': AppLocalizations.of(context)?.myFollowedGroups,
                      'applyJoin': true,
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 2,
            children: [
              _buildCard(
                context,
                Colors.red[300]!,
                Icons.block,
                AppLocalizations.of(context)!.deleteAccount,
                () {
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
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    Color color,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40),
                const SizedBox(height: 10),
                Text(title, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
