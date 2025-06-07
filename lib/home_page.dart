import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/general/app_routes.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _wrapWithListener(Widget child) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedoutAuthState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.signin,
            ModalRoute.withName(AppRoutes.myApp),
          );
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
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _wrapWithListener(
      Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
          ],
        ),
        body: Center(child: Text("Home Page")),
      ),
    );
  }
}
