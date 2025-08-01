import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/core/util/widgets/error_page.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_role.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/follow_bloc/follow_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/update_group_member_role_bloc/update_group_member_role_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/users_bloc/accounts_bloc.dart';
import 'package:prism/features/account/presentation/widgets/simplified_account_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountsPage extends StatefulWidget {
  final String appBarTitle;
  final Function(BuildContext) triggerEvent;
  final bool isGroupMembersPage;
  final bool updateGroupRole;
  final int? groupId;

  const AccountsPage({
    super.key,
    required this.appBarTitle,
    required this.triggerEvent,
    required this.isGroupMembersPage,
    required this.updateGroupRole,
    this.groupId,
  });

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  void initState() {
    super.initState();
    widget.triggerEvent(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildWithBloc();
  }

  Widget _buildWithBloc() {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        Widget stateWidget = Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        );
        if (state is LoadedAccountsState) {
          if (state.accounts.isEmpty) {
            stateWidget = SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Center(child: Text(AppLocalizations.of(context)!.noData)),
            );
          } else {
            stateWidget = _buildAccounts(state.accounts);
          }
        } else if (state is FailedAccountsState) {
          stateWidget = SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: CustomErrorWidget(msg: state.failure.message),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(widget.appBarTitle),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          body: RefreshIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
            onRefresh: () async {
              widget.triggerEvent(context);
            },
            child: stateWidget,
          ),
        );
      },
    );
  }

  Widget _buildAccounts(List<SimplifiedAccountEntity> accounts) {
    return BlocBuilder<PAccountBloc, PAccountState>(
      builder: (context, pAccountState) {
        if (pAccountState is LoadedPAccountState) {
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: accounts.length,
            itemBuilder:
                (context, index) => BlocProvider<UpdateGroupMemberRoleBloc>(
                  create: (context) => sl<UpdateGroupMemberRoleBloc>(),
                  child: BlocListener<
                    UpdateGroupMemberRoleBloc,
                    UpdateGroupMemberRoleState
                  >(
                    listener: (context, state) {
                      if (state is UpdateGroupMemberRoleSuccess) {
                        widget.triggerEvent(context);
                      }
                    },
                    child: BlocProvider<FollowBloc>(
                      create: (context) => sl<FollowBloc>(),
                      child: Builder(
                        builder:
                            (context) => SimplifiedAccountWidget(
                              account: accounts[index],
                              personalAccId: pAccountState.personalAccount.id,
                              isGroupMembersPage: widget.isGroupMembersPage,
                              updateGroupRole: widget.updateGroupRole,
                              onLongPress: () {
                                if (widget.updateGroupRole) {
                                  _showUpdateRoleBottomSheet(
                                    context,
                                    accounts[index],
                                  );
                                }
                              },
                            ),
                      ),
                    ),
                  ),
                ),
          );
        }
        return Container();
      },
    );
  }

  void _showUpdateRoleBottomSheet(
    BuildContext context,
    SimplifiedAccountEntity account,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: Text(
                account.role == AccountRole.admin
                    ? AppLocalizations.of(context)!.demoteToMember
                    : AppLocalizations.of(context)!.promoteToAdmin,
              ),
              onTap: () {
                context.read<UpdateGroupMemberRoleBloc>().add(
                  UpdateRole(
                    groupId: widget.groupId!,
                    userId: account.id,
                    role:
                        account.role == AccountRole.admin
                            ? AccountRole.member
                            : AccountRole.admin,
                  ),
                );
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }
}
