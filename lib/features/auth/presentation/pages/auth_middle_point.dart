import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/loading_page.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';

class AuthMiddlePointPage extends StatelessWidget {
  const AuthMiddlePointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedoutAuthState) {
          Navigator.pushReplacementNamed(context, AppRoutes.signin);
        } else if (state is LoggedInAuthState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.accMiddlePoint,
            ModalRoute.withName(AppRoutes.myApp),
          );
        } else if (state is NotVerifiedAuthState) {
          Navigator.pushReplacementNamed(context, AppRoutes.verification);
        } else if (state is FailedAuthState) {
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
