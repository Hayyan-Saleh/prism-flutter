import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/loading_page.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';

class AccountMiddlePointPage extends StatelessWidget {
  const AccountMiddlePointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PAccountBloc, PAccountState>(
      listener: (context, state) {
        if (state is LoggedoutAuthState) {
          Navigator.pushReplacementNamed(context, AppRoutes.signin);
        } else if (state is LoadedPAccountState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            ModalRoute.withName(AppRoutes.myApp),
          );
        } else if (state is PAccountNotCreatedState) {
          Navigator.pushReplacementNamed(context, AppRoutes.updateAccount);
        } else if (state is FailedPAccountState) {
          showCustomAboutDialog(
            context,
            "Error",
            state.failure.message,
            null,
            true,
          );
        }
      },
      child: LoadingPage(),
    );
  }
}
