import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/other_account_bloc/other_account_bloc.dart';

class BlockedAccountListTile extends StatelessWidget {
  final int personalAccId;
  final SimplifiedAccountEntity account;

  const BlockedAccountListTile({
    super.key,
    required this.account,
    required this.personalAccId,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap:
            () => Navigator.pushNamed(
              context,
              AppRoutes.otherAccPage,
              arguments: {
                'personalAccountId': personalAccId,
                'otherAccountId': account.id,
              },
            ),
        leading: ProfilePicture(link: account.avatar, radius: 30),
        title: Text(
          account.fullName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '@${account.accountName}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: AppButton(
          onPressed: () {
            context.read<OAccountBloc>().add(
              UnblockUserEvent(targetId: account.id),
            );
          },
          child: Text(local.unblockUser),
        ),
      ),
    );
  }
}
