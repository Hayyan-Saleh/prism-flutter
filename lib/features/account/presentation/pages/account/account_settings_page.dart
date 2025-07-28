import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      body: SingleChildScrollView(
        child: Column(
          spacing: 8,
          children: [
            ListTile(
              trailing: const Icon(Icons.person),
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
              trailing: const Icon(Icons.block),
              title: Text(AppLocalizations.of(context)!.blockedAccounts),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.blockedAccounts);
              },
            ),
            ListTile(
              trailing: const Icon(Icons.group_add),
              title: Text(AppLocalizations.of(context)!.createGroup),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AppRoutes.createGroup);
              },
            ),
            ListTile(
              trailing: const Icon(Icons.archive),
              title: Text(AppLocalizations.of(context)!.archivedStatuses),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  AppRoutes.archivedStatuses,
                  arguments: {'isAddToHighlightMode': true},
                );
              },
            ),
            ListTile(
              trailing: const Icon(Icons.block, color: Colors.red),
              title: Text(
                AppLocalizations.of(context)!.deleteAccount,
                style: const TextStyle(color: Colors.red),
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
      ),
    );
  }
}
