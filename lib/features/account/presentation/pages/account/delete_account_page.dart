import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,

      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.deleteAccount),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.deleteAccount,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.deleteAccountConfirmation,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              bgColor: Colors.red,
              fgColor: Colors.white,
              onPressed: () {
                context.read<PAccountBloc>().add(DeletePAccountEvent());
              },
              child: BlocBuilder<PAccountBloc, PAccountState>(
                builder: (context, state) {
                  if (state is LoadingPAccountState) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  return Text(AppLocalizations.of(context)!.deleteAccount);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
