import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/sevices/notification_service.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/loading_page.dart';
import 'package:prism/features/auth/domain/entities/user_entity.dart';
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
          state.user.fcmToken == null
              ? _showNotificationPermissionDialog(context, state.user)
              : _navigateToAccountMiddlePoint(context);
        } else if (state is NotVerifiedAuthState) {
          Navigator.pushReplacementNamed(context, AppRoutes.verification);
        } else if (state is DoneAddFCMAuthState) {
          _navigateToAccountMiddlePoint(context);
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

  void _showNotificationPermissionDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Enable Notifications?'),
            content: const Text(
              'Would you like to enable notifications to stay updated?',
            ),
            actions: [
              AppButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateToAccountMiddlePoint(context);
                },
                child: const Text('Later'),
              ),
              AppButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final notificationService = sl<NotificationService>();
                  final fcmToken = await notificationService.getFCMToken();
                  if (fcmToken != null) {
                    if (context.mounted) {
                      context.read<AuthBloc>().add(
                        StoreFcmTokenEvent(fcmToken),
                      );
                    }
                  }
                },
                child: const Text('Enable'),
              ),
            ],
          ),
    );
  }

  void _navigateToAccountMiddlePoint(BuildContext context) {
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.accMiddlePoint,
      ModalRoute.withName(AppRoutes.myApp),
    );
  }
}
