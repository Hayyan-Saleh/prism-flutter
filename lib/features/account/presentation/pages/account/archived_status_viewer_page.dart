import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:prism/features/account/presentation/widgets/show_status_widget.dart';

class ArchivedStatusViewerPage extends StatefulWidget {
  const ArchivedStatusViewerPage({
    super.key,
  });

  @override
  State<ArchivedStatusViewerPage> createState() =>
      _ArchivedStatusViewerPageState();
}

class _ArchivedStatusViewerPageState extends State<ArchivedStatusViewerPage> {
  @override
  Widget build(BuildContext context) {
    final pAccount = context.read<PAccountBloc>().pAccount;
    if (pAccount == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.personalAccountNotFound,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider<StatusBloc>(
        create: (context) => sl<StatusBloc>(),
        child: ShowStatusWidget(
          userId: pAccount.id,
        ),
      ),
    );
  }
}
