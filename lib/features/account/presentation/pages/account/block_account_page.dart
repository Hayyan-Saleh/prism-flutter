import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/features/account/presentation/bloc/account/other_account_bloc/other_account_bloc.dart';

class BlockAccountPage extends StatelessWidget {
  final String fullName;
  final int otherAccountId;

  const BlockAccountPage({
    super.key,
    required this.fullName,
    required this.otherAccountId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<OAccountBloc, OAccountState>(
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
                  Navigator.of(context).pop(); // Pop dialog
                  Navigator.of(context).pop(); // Pop BlockAccountPage
                  Navigator.of(context).pop(); // Pop OtherAccountPage
                },
              ),
            ],
            false,
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
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.blockUser),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.block, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.blockUserQuestion(fullName),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.blockUserExplanation,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppButton(
                bgColor: Colors.red,
                fgColor: Colors.white,
                onPressed: () {
                  context.read<OAccountBloc>().add(
                    BlockUserEvent(targetId: otherAccountId),
                  );
                },
                child: BlocBuilder<OAccountBloc, OAccountState>(
                  builder: (context, state) {
                    if (state is LoadingOAccountState) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                    return Text(AppLocalizations.of(context)!.blockUser);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
