import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/other_account_bloc/other_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/users_bloc/accounts_bloc.dart';
import 'package:prism/features/account/presentation/widgets/blocked_account_list_tile.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlockedAccountsPage extends StatefulWidget {
  const BlockedAccountsPage({super.key});

  @override
  State<BlockedAccountsPage> createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  @override
  void initState() {
    _getBlockedUsers();
    super.initState();
  }

  void _getBlockedUsers() {
    context.read<AccountsBloc>().add(GetBlockedAccountsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(local.blockedAccounts),
        backgroundColor: Colors.transparent,
      ),
      body: _wrapWithAccountBloc(),
    );
  }

  Widget _wrapWithAccountBloc() {
    return BlocListener<OAccountBloc, OAccountState>(
      listener: (context, state) {
        if (state is UserUnblockedState) _getBlockedUsers();
      },
      child: BlocBuilder<PAccountBloc, PAccountState>(
        builder: (context, state) {
          final PersonalAccountEntity? pAccount =
              state is LoadedPAccountState
                  ? state.personalAccount
                  : context.read<PAccountBloc>().pAccount;

          if (pAccount != null) return _handleAccountsBloc(pAccount.id);
          return const SizedBox();
        },
      ),
    );
  }

  Widget _handleAccountsBloc(int pAccountId) {
    final local = AppLocalizations.of(context)!;
    return BlocConsumer<AccountsBloc, AccountsState>(
      listener: (context, state) {
        if (state is BlockedAccountsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is LoadingAccountsState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BlockedAccountsLoaded) {
          if (state.blockedAccounts.isEmpty) {
            return Center(child: Text(local.noBlockedAccounts));
          }
          return ListView.builder(
            itemCount: state.blockedAccounts.length,
            itemBuilder: (context, index) {
              final account = state.blockedAccounts[index];
              return BlockedAccountListTile(
                personalAccId: pAccountId,
                account: account,
              );
            },
          );
        }
        return Center(child: Text(local.somethingWentWrong));
      },
    );
  }
}
