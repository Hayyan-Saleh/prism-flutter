import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/sevices/assets.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/main/other_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/follow_bloc/follow_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/other_account_bloc/other_account_bloc.dart';
import 'package:prism/features/account/presentation/widgets/personal_info_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtherAccountPage extends StatefulWidget {
  final int personalAccountId;
  final int otherAccountId;

  const OtherAccountPage({
    super.key,
    required this.personalAccountId,
    required this.otherAccountId,
  });

  @override
  State<OtherAccountPage> createState() => _OtherAccountPageState();
}

class _OtherAccountPageState extends State<OtherAccountPage> {
  @override
  void initState() {
    context.read<OAccountBloc>().add(
      LoadOAccountEvent(id: widget.otherAccountId),
    );
    super.initState();
  }

  AppBar _profileAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: BlocBuilder<OAccountBloc, OAccountState>(
        builder: (context, state) {
          if (state is LoadedOAccountState) {
            return Text(
              state.otherAccount.fullName,
              style: Theme.of(context).textTheme.titleLarge,
            );
          } else if (context.read<OAccountBloc>().oAccount != null) {
            return Text(
              context.read<OAccountBloc>().oAccount!.fullName,
              style: Theme.of(context).textTheme.titleLarge,
            );
          }
          return SizedBox();
        },
      ),
      actions: [
        BlocBuilder<OAccountBloc, OAccountState>(
          builder: (context, state) {
            bool isBlocked = false;
            if (state is LoadedOAccountState) {
              isBlocked = state.otherAccount.isBlocked;
            } else if (context.read<OAccountBloc>().oAccount != null) {
              isBlocked = context.read<OAccountBloc>().oAccount!.isBlocked;
            }
            if (!isBlocked) {
              return IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  _showBlockBottomSheet(context);
                },
              );
            }
            return SizedBox();
          },
        ),
      ],
    );
  }

  void _showBlockBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          height: 100,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.block, color: Colors.red),
                title: Text(
                  AppLocalizations.of(bottomSheetContext)!.blockUser,
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  final oAccountState = context.read<OAccountBloc>().state;
                  if (oAccountState is LoadedOAccountState) {
                    Navigator.pop(bottomSheetContext); // dismiss bottom sheet
                    Navigator.pushNamed(
                      context,
                      AppRoutes.blocAccPage,
                      arguments: {
                        'fullName': oAccountState.otherAccount.fullName,
                        'otherAccountId': oAccountState.otherAccount.id,
                      },
                    );
                  } else if (context.read<OAccountBloc>().oAccount != null) {
                    final oAccount = context.read<OAccountBloc>().oAccount!;
                    Navigator.pop(bottomSheetContext); // dismiss bottom sheet
                    Navigator.pushNamed(
                      context,
                      AppRoutes.blocAccPage,
                      arguments: {
                        'fullName': oAccount.fullName,
                        'otherAccountId': oAccount.id,
                      },
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFollowBloc(
    FollowStatus followStatus,
    bool isPrivate,
    bool isBlockedByMe,
  ) {
    return BlocConsumer<FollowBloc, FollowState>(
      listener: (context, state) {
        if (state is FailedFollowState) {
          showCustomAboutDialog(
            context,
            AppLocalizations.of(context)!.error,
            state.failure.message,
            null,
            true,
          );
        }
      },
      builder: (context, state) {
        final secondaryColor = Theme.of(context).colorScheme.secondary;
        String btnTxt = "";
        Color btnColor =
            state is LoadingFollowState
                ? secondaryColor.withAlpha(100)
                : secondaryColor;

        if (isBlockedByMe) {
          btnTxt = AppLocalizations.of(context)!.unblockUser;
          btnColor = Colors.red;
        } else {
          FollowStatus currentStatus = followStatus;
          if (state is DoneFollowState) {
            currentStatus = state.newStatus;
          }

          if (currentStatus == FollowStatus.pending) {
            btnTxt = AppLocalizations.of(context)!.pending;
          } else if (currentStatus == FollowStatus.following) {
            btnTxt = AppLocalizations.of(context)!.unfollow;
          } else {
            btnTxt =
                isPrivate
                    ? AppLocalizations.of(context)!.requestToFollow
                    : AppLocalizations.of(context)!.follow;
          }

          if (state is FailedFollowState) {
            btnTxt = AppLocalizations.of(context)!.errorPleaseRefresh;
            btnColor = btnColor.withAlpha(100);
          }
        }

        return Row(
          children: [
            Expanded(
              child: AppButton(
                bgColor: btnColor,
                onPressed: () {
                  if (isBlockedByMe) {
                    context.read<OAccountBloc>().add(
                      UnblockUserEvent(targetId: widget.otherAccountId),
                    );
                  } else {
                    _onFollowPressed(followStatus != FollowStatus.following);
                  }
                },
                child: Text(
                  btnTxt,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onFollowPressed(bool newStatus) {
    context.read<FollowBloc>().add(
      ToggleFollowEvent(newStatus: newStatus, targetId: widget.otherAccountId),
    );
  }

  Widget _buildFollowersWidget(
    OtherAccountEntity account,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap:
          account.isBlocked
              ? null
              : () {
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
    OtherAccountEntity account,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap:
          account.isBlocked
              ? null
              : () {
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
        SizedBox(),
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
                              "followers",
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

  FollowStatus _filterStatus(FollowStatus status) {
    return status == FollowStatus.following
        ? FollowStatus.following
        : FollowStatus.notFollowing;
  }

  Widget _buildProfilePic(OtherAccountEntity otherAccount) {
    return GestureDetector(
      onTap:
          otherAccount.hasStatus && !otherAccount.isBlocked
              ? () {
                FollowStatus followStatus = _filterStatus(
                  otherAccount.followingStatus,
                );
                BlocListener<FollowBloc, FollowState>(
                  listener: (context, state) {
                    if (state is DoneFollowState) {
                      followStatus = _filterStatus(state.newStatus);
                    }
                  },
                );

                Navigator.pushNamed(
                  context,
                  AppRoutes.showStatusPage,
                  arguments: {
                    'userId': otherAccount.id,
                    'followStatus': followStatus,
                  },
                );
              }
              : null,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Hero(
          tag: 'showStatusTag',
          child: ProfilePicture(
            link: otherAccount.picUrl ?? '',
            hasStatus: otherAccount.hasStatus,
            radius: 42,
          ),
        ),
      ),
    );
  }

  Widget _buildFirstSection(OtherAccountEntity otherAccount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildProfilePic(otherAccount),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.11 * getWidth(context),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFollowersWidget(otherAccount, context),
                        _buildFollowingWidget(otherAccount, context),
                      ],
                    ),
                    _buildFollowBloc(
                      otherAccount.followingStatus,
                      otherAccount.isPrivate,
                      otherAccount.isBlocked,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8),
          child: Text(
            otherAccount.accountName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (otherAccount.bio != '')
          Container(
            margin: const EdgeInsets.only(left: 16.0, top: 8),
            child: Text(
              otherAccount.bio,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(150),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHighlightsSection() {
    // TODO: add Status Bloc
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
    return Text(AppLocalizations.of(context)!.postsSection);
  }

  Widget _buildPersonalInfoSection(OtherAccountEntity account) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: PersonalInfoWidget(
        userName: account.fullName,
        personalInfo: account.personalInfos,
        onToggleExpand: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildHiddenDataWidget(bool fromPrivacy) {
    return Padding(
      padding: EdgeInsets.only(
        top: .15 * getHeight(context),
        left: 16,
        right: 16,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 0.05 * getHeight(context),
          children: [
            SvgPicture.asset(Assets.locked2, height: 0.25 * getHeight(context)),

            Text(
              fromPrivacy
                  ? AppLocalizations.of(context)!.hiddenUserPrivacy
                  : AppLocalizations.of(context)!.hiddenUserBlock,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _handleOAccountBloc() {
    return BlocConsumer<OAccountBloc, OAccountState>(
      listener: (context, state) {
        if (state is UserBlockedState) {
          showCustomAboutDialog(
            context,

            AppLocalizations.of(context)!.success,
            AppLocalizations.of(context)!.userBlocked,
            [
              AppButton(
                child: Text(AppLocalizations.of(context)!.ok),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
            true,
          );
        } else if (state is FailedOAccountState) {
          showCustomAboutDialog(
            context,
            AppLocalizations.of(context)!.error,
            state.failure.message,
            null,
            true,
          );
        }
      },
      builder: (context, state) {
        OtherAccountEntity? account;
        if (state is LoadedOAccountState) {
          account = state.otherAccount;
        } else if (context.read<OAccountBloc>().oAccount != null) {
          account = context.read<OAccountBloc>().oAccount!;
        }

        if (account == null) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [_buildFirstSectionSkeleton(context: context)],
            ),
          );
        }

        final bool isPrivateAndNotFollowing =
            account.isPrivate &&
            account.followingStatus == FollowStatus.notFollowing;
        final bool isBlockedByMe = account.isBlocked;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildFirstSection(account),
              if (isPrivateAndNotFollowing)
                _buildHiddenDataWidget(true)
              else if (isBlockedByMe)
                _buildHiddenDataWidget(false)
              else ...[
                if (account.personalInfos.isNotEmpty)
                  _buildPersonalInfoSection(account),
                _buildHighlightsSection(),
                _buildPostsSection(),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _profileAppBar(),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        onRefresh: () async {
          context.read<OAccountBloc>().add(
            LoadOAccountEvent(id: widget.otherAccountId),
          );
        },
        child: _handleOAccountBloc(),
      ),
    );
  }
}
