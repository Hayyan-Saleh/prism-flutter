import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/users_bloc/accounts_bloc.dart';
import 'package:prism/features/account/presentation/widgets/personal_info_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalAccountPage extends StatefulWidget {
  const PersonalAccountPage({super.key});

  @override
  State<PersonalAccountPage> createState() => _PersonalAccountPageState();
}

class _PersonalAccountPageState extends State<PersonalAccountPage> {
  @override
  void initState() {
    context.read<PAccountBloc>().add(LoadRemotePAccountEvent());
    super.initState();
  }

  Widget _buildFollowersWidget(
    PersonalAccountEntity account,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap:
          () => Navigator.of(context).pushNamed(
            AppRoutes.accounts,
            arguments: {
              'appBarTitle': AppLocalizations.of(
                context,
              )!.followersTitle(account.fullName),
              'triggerEvent': (BuildContext blocContext) {
                blocContext.read<AccountsBloc>().add(
                  GetFollowersAccountsEvent(accountId: account.id),
                );
              },
            },
          ),
      child: Column(
        spacing: 4,
        children: [
          Text(
            AppLocalizations.of(context)!.followers,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          Text(
            account.followersCount.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingWidget(
    PersonalAccountEntity account,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap:
          () => Navigator.of(context).pushNamed(
            AppRoutes.accounts,
            arguments: {
              'appBarTitle': AppLocalizations.of(
                context,
              )!.followingTitle(account.fullName),
              'triggerEvent': (BuildContext blocContext) {
                blocContext.read<AccountsBloc>().add(
                  GetFollowingAccountsEvent(accountId: account.id),
                );
              },
            },
          ),
      child: Column(
        spacing: 4,
        children: [
          Text(
            AppLocalizations.of(context)!.following,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            account.followingCount.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildFirstSectionSkeleton({BuildContext? context}) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ProfilePicture(link: '', hasStatus: false, radius: 42),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (context != null) ...[
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.followers ??
                              'followers',
                        ),
                        Text(''),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.following ??
                              'following',
                        ),
                        Text(''),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            '',
            style:
                context != null ? Theme.of(context).textTheme.titleLarge : null,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: Text(
            '',
            style:
                context != null
                    ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withAlpha(150),
                    )
                    : null,
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePic(PersonalAccountEntity personalAccount) {
    return GestureDetector(
      onTap:
          personalAccount.hasStatus
              ? () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.showStatusPage,
                  arguments: {
                    'userId': personalAccount.id,
                    'personalStatuses': true,
                  },
                );
              }
              : null,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ProfilePicture(
          link: personalAccount.picUrl ?? '',
          hasStatus: personalAccount.hasStatus,
          radius: 42,
        ),
      ),
    );
  }

  Widget _buildFirstSection(BuildContext context) {
    return BlocBuilder<PAccountBloc, PAccountState>(
      builder: (context, state) {
        final account =
            state is LoadedPAccountState
                ? state.personalAccount
                : context.read<PAccountBloc>().pAccount;

        if (account != null) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildProfilePic(account),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFollowersWidget(account, context),
                          _buildFollowingWidget(account, context),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text(
                    account.accountName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (account.bio.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 16.0, top: 8),
                    child: Text(
                      account.bio,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withAlpha(150),
                      ),
                    ),
                  ),
                if (account.personalInfos.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: PersonalInfoWidget(
                      userName: account.fullName,
                      personalInfo: account.personalInfos,
                      onToggleExpand: () => setState(() {}),
                    ),
                  ),
              ],
            ),
          );
        }
        return _buildFirstSectionSkeleton(context: context);
      },
    );
  }

  Widget _buildHighlightsSection(context) {
    // TODO: CREATE Status Bloc
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8),
          child: Text(
            AppLocalizations.of(context)!.highlights,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(
                10,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 8,
                    children: [
                      ProfilePicture(link: '', hasStatus: true, radius: 32),
                      Text(
                        "28/$index/24",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostsSection() {
    // TODO: RAFAT POSTS ADDED HERE as widget (if wanted to add a list view or single child scroll view then make no scroll physics)
    return Text(AppLocalizations.of(context)!.postsSection);
  }

  Widget _wrapWithRefreshIndicator({
    required BuildContext context,
    required Widget child,
  }) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      onRefresh: () async {
        context.read<PAccountBloc>().add(LoadRemotePAccountEvent());
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _wrapWithRefreshIndicator(
      context: context,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildFirstSection(context),
            _buildHighlightsSection(context),
            _buildPostsSection(),
          ],
        ),
      ),
    );
  }
}
