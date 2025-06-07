import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realmo/core/util/general/app_routes.dart';
import 'package:realmo/core/util/widgets/loading_page.dart';
import 'package:realmo/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';

class AuthMiddlePointPage extends StatelessWidget {
  const AuthMiddlePointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedoutAuthState) {
          Navigator.pushReplacementNamed(context, AppRoutes.signin);
        } else if (state is LoggedInAuthState) {
          // TODO: Navigate to the account middle point
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            ModalRoute.withName(AppRoutes.myApp),
          );
        } else if (state is NotVerifiedAuthState) {
          Navigator.pushReplacementNamed(context, AppRoutes.verification);
        }
      },
      child: LoadingPage(),
    );
  }
}
