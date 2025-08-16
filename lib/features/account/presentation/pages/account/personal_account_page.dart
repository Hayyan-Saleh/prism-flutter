import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/post/post_bloc/post_bloc.dart';
import 'package:prism/features/account/presentation/widgets/personal_info_widget.dart';
import 'package:prism/core/localization/l10n/app_localizations.dart';
import 'package:prism/features/account/presentation/widgets/post/posts_list_widget.dart';

class PersonalAccountPage extends StatefulWidget {
  const PersonalAccountPage({super.key});

  @override
  State<PersonalAccountPage> createState() => PersonalAccountPageState();
}

class PersonalAccountPageState extends State<PersonalAccountPage> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    context.read<PAccountBloc>().add(LoadRemotePAccountEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _loadPersonalPosts();
      _isLoaded = true;
    }
  }

  void _loadPersonalPosts({int pageNum = 1}) {
    final pAccount = context.read<PAccountBloc>().pAccount;
    if (pAccount != null) {
      context.read<PostBloc>().add(
        LoadPersonalPosts(userId: pAccount.id, pageNum: pageNum),
      );
    }
  }

  Widget _buildFollowersWidget(
    PersonalAccountEntity account,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.accounts,
          arguments: {'personalAccount': account, 'following': false},
        );
      },
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.followers,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.accounts,
          arguments: {'personalAccount': account, 'following': true},
        );
      },
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.following,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        const SizedBox(height: 16),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)?.following ??
                              'following',
                        ),
                        const SizedBox(height: 16),
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
                    children: [
                      ProfilePicture(link: '', hasStatus: true, radius: 32),
                      Text(
                        "28/$index/24",
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.message)));
        }
      },
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PersonalPostsLoadedSuccess) {
            return PostsListWidget(posts: state.paginatedPosts.posts);
          } else if (state is PostError) {
            return Center(child: Text('Error: ${state.failure.message}'));
          }
          return const Center(child: Text('No posts available'));
        },
      ),
    );
  }

  Widget _wrapWithRefreshIndicator({
    required BuildContext context,
    required Widget child,
  }) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      onRefresh: () async {
        context.read<PAccountBloc>().add(LoadRemotePAccountEvent());
        _loadPersonalPosts();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
