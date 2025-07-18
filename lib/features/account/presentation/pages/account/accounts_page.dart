import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/core/util/widgets/error_page.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/follow_bloc/follow_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/users_bloc/accounts_bloc.dart';
import 'package:prism/features/account/presentation/widgets/simplified_account_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountsPage extends StatefulWidget {
  final String appBarTitle;
  final Function(BuildContext) triggerEvent;

  const AccountsPage({
    super.key,
    required this.appBarTitle,
    required this.triggerEvent,
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
      builder: (context, state) {
        if (state is LoadedPAccountState) {
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: accounts.length,
            itemBuilder:
                (context, index) => BlocProvider<FollowBloc>(
                  create: (context) => sl<FollowBloc>(),
                  child: SimplifiedAccountWidget(
                    account: accounts[index],
                    personalAccId: state.personalAccount.id,
                    isPrivate: accounts[index].isPrivate,
                  ),
                ),
          );
        } else if (state is FailedPAccountState) {
          return ErrorPage(msg: state.failure.message);
        }
        return Container();
      },
    );
  }
}
