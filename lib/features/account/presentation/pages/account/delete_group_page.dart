import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/features/account/presentation/bloc/account/group_bloc/group_bloc.dart';

class DeleteGroupPage extends StatelessWidget {
  final int groupId;
  final String groupName;

  const DeleteGroupPage(
      {super.key, required this.groupId, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.deleteGroupTitle),
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
              AppLocalizations.of(context)!.deleteGroupName(groupName),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.deleteGroupConfirmation,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              bgColor: Colors.red,
              fgColor: Colors.white,
              onPressed: () {
                context.read<GroupBloc>().add(DeleteGroup(groupId: groupId));
              },
              child: BlocConsumer<GroupBloc, GroupState>(
                listener: (context, state) {
                  if (state is GroupDeleteSuccess) {
                    Navigator.of(context).pop(true);
                  } else if (state is GroupDeleteFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GroupLoading) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  return Text(AppLocalizations.of(context)!.deleteGroup);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
