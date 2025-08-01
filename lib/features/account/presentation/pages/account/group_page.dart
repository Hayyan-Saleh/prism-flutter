import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/sevices/assets.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_role.dart';
import 'package:prism/features/account/domain/enitities/account/main/group_entity.dart';
import 'package:prism/features/account/domain/enitities/account/main/join_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/group_bloc/group_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/join_group_bloc/join_group_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/users_bloc/accounts_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupPage extends StatefulWidget {
  final int groupId;
  const GroupPage({super.key, required this.groupId});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  void initState() {
    super.initState();
    _fetchGroupData();
  }

  void _fetchGroupData() {
    context.read<GroupBloc>().add(GetGroupEvent(groupId: widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: BlocBuilder<GroupBloc, GroupState>(builder: _buildAppBarTitle),
    );
  }

  Widget _buildAppBarTitle(BuildContext context, GroupState state) {
    if (state is GroupLoaded) {
      return Text(state.group.name);
    }
    return Text(AppLocalizations.of(context)!.groupPageTitle);
  }

  Widget _buildBody() {
    return MultiBlocListener(
      listeners: [
        BlocListener<GroupBloc, GroupState>(
          listener: (context, state) {
            if (state is GroupDeleteSuccess) {
              Navigator.of(context).pop();
            } else if (state is GroupDeleteFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        BlocListener<JoinGroupBloc, JoinGroupState>(
          listener: (context, state) {
            if (state is JoinGroupFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.failure.message)));
            }
            if (state is JoinGroupSuccess) {
              _fetchGroupData();
            }
          },
        ),
      ],
      child: BlocBuilder<GroupBloc, GroupState>(builder: _buildBodyContent),
    );
  }

  Widget _buildBodyContent(BuildContext context, GroupState state) {
    if (state is GroupLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is GroupFailure) {
      return Center(child: Text(state.message));
    }
    if (state is GroupLoaded) {
      return _buildGroupContent(state.group);
    }
    return Center(
      child: Text(AppLocalizations.of(context)!.somethingWentWrong),
    );
  }

  Widget _buildGroupContent(GroupEntity group) {
    final bool isOwner = group.role == AccountRole.owner;
    final bool isAdmin = group.role == AccountRole.admin;
    final bool isPrivateAndNotJoined =
        group.privacy == 'private' && group.joinStatus != JoinStatus.joined;

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      onRefresh: () async {
        _fetchGroupData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _buildGroupHeader(group),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGroupOwner(group.owner, isOwner),
                  isOwner || isAdmin
                      ? _buildModifyWidget(group)
                      : _buildJoinBloc(group),
                ],
              ),
              const Divider(),
              if (isPrivateAndNotJoined)
                _buildHiddenDataWidget()
              else
                _buildPostsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(GroupEntity group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGroupImage(group.avatar ?? ''),
        const SizedBox(height: 8),
        _buildGroupName(group.name),
        const SizedBox(height: 8),
        _buildGroupBio(group.bio ?? ''),
      ],
    );
  }

  Widget _buildGroupOwner(SimplifiedAccountEntity owner, bool isOwner) {
    return GestureDetector(
      onTap:
          isOwner
              ? null
              : () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.otherAccPage,
                  arguments: {'otherAccountId': owner.id},
                );
              },
      child: Row(
        children: [
          ProfilePicture(
            link: owner.avatar,
            radius: 32,
            role: AccountRole.owner,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.owner,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                owner.fullName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModifyWidget(GroupEntity group) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.accounts,
              arguments: {
                'appBarTitle': AppLocalizations.of(
                  context,
                )!.groupMembers(group.name),
                'triggerEvent': (BuildContext blocContext) {
                  blocContext.read<AccountsBloc>().add(
                    GetGroupMembersEvent(groupId: group.id),
                  );
                },
                'isGroupMembersPage': true,
                'updateGroupRole':
                    group.role != null && group.role == AccountRole.owner,
                'groupId': group.id,
              },
            );
          },
          child: Text(
            AppLocalizations.of(context)!.membersCount(group.membersCount ?? 0),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 0.5 * getWidth(context),
          child: AppButton(
            bgColor: const Color.fromARGB(175, 50, 150, 200),
            fgColor: Colors.white,
            child: Text(
              AppLocalizations.of(context)!.settings,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              _showSettingsBottomSheet(context, group);
            },
          ),
        ),
      ],
    );
  }

  void _showSettingsBottomSheet(BuildContext context, GroupEntity group) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        if (group.role == AccountRole.owner) {
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: Text(AppLocalizations.of(context)!.groupRequests),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.groupJoinRequests,
                    arguments: {'groupId': group.id},
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(AppLocalizations.of(context)!.updateGroup),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.updateGroup,
                    arguments: {'group': group},
                  ).then((updated) {
                    if (updated is bool && updated) {
                      _fetchGroupData();
                    }
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: Text(AppLocalizations.of(context)!.deleteGroup),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.deleteGroup,
                    arguments: {'groupId': group.id, 'groupName': group.name},
                  ).then((deleted) {
                    if (deleted is bool && deleted) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  });
                },
              ),
            ],
          );
        } else {
          // Admin
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.person_add),
                title: Text(AppLocalizations.of(context)!.groupRequests),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.groupJoinRequests,
                    arguments: {'groupId': group.id},
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(AppLocalizations.of(context)!.leave),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<JoinGroupBloc>().add(
                    ToggleJoinGroupEvent(groupId: group.id, join: false),
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildJoinBloc(GroupEntity group) {
    return BlocBuilder<JoinGroupBloc, JoinGroupState>(
      builder: (context, state) {
        final secondaryColor = Theme.of(context).colorScheme.secondary;
        String btnTxt = "";
        Color btnColor =
            state is JoinGroupLoading
                ? secondaryColor.withAlpha(100)
                : secondaryColor;

        if (group.joinStatus == JoinStatus.pending) {
          btnTxt = AppLocalizations.of(context)!.pending;
        } else if (group.joinStatus == JoinStatus.joined) {
          btnTxt = AppLocalizations.of(context)!.leave;
        } else {
          btnTxt =
              group.privacy == 'private'
                  ? AppLocalizations.of(context)!.requestJoin
                  : AppLocalizations.of(context)!.join;
        }

        if (state is JoinGroupFailure) {
          btnTxt = AppLocalizations.of(context)!.errorPleaseRefresh;
          btnColor = btnColor.withAlpha(100);
        }

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.accounts,
                  arguments: {
                    'appBarTitle': AppLocalizations.of(
                      context,
                    )!.groupMembers(group.name),
                    'triggerEvent': (BuildContext blocContext) {
                      blocContext.read<AccountsBloc>().add(
                        GetGroupMembersEvent(groupId: group.id),
                      );
                    },
                    'isGroupMembersPage': true,
                  },
                );
              },
              child: Text(
                AppLocalizations.of(
                  context,
                )!.membersCount(group.membersCount ?? 0),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 0.5 * getWidth(context),
              child: AppButton(
                bgColor: btnColor,
                onPressed: () {
                  context.read<JoinGroupBloc>().add(
                    ToggleJoinGroupEvent(
                      groupId: group.id,
                      join: group.joinStatus != JoinStatus.joined,
                    ),
                  );
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

  Widget _buildGroupImage(String link) {
    return SizedBox(
      height: 0.2 * getHeight(context),
      width: getWidth(context),
      child: _buildCachedImage(link),
    );
  }

  Widget _buildGroupName(String name) {
    return Text(name, style: Theme.of(context).textTheme.headlineSmall);
  }

  Widget _buildGroupBio(String bio) {
    return Text(
      AppLocalizations.of(context)!.groupBioText(bio),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary.withAlpha(200),
      ),
    );
  }

  Widget _buildPostsSection() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(AppLocalizations.of(context)!.noPostsYet),
      ),
    );
  }

  Widget _buildHiddenDataWidget() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(Assets.locked2, height: 0.25 * getHeight(context)),
        Text(
          AppLocalizations.of(context)!.hiddenGroupPrivacy,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildCachedImage(String link) {
    return CachedNetworkImage(
      imageUrl: link,
      imageBuilder:
          (context, imageProvider) => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(image: imageProvider, fit: BoxFit.cover),
          ),
      placeholder:
          (context, url) => const SizedBox(
            height: 100,
            width: 100,
            child: Center(child: CircularProgressIndicator(strokeWidth: 4)),
          ),
      errorWidget:
          (context, url, error) => const SizedBox(
            height: 100,
            width: 100,
            child: Center(child: Icon(Icons.error)),
          ),
    );
  }
}
