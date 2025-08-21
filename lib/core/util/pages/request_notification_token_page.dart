import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:prism/core/localization/l10n/app_localizations.dart';

class RequestNotificationTokenPage extends StatelessWidget {
  const RequestNotificationTokenPage({super.key});

  void _navigateToAccountMiddlePoint(BuildContext context) {
    if (!context.mounted) return;

    context.read<PAccountBloc>().add(LoadRemotePAccountEvent());
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.accMiddlePoint,
      ModalRoute.withName(AppRoutes.myApp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is DoneAddFCMAuthState) {
          _navigateToAccountMiddlePoint(context);
        }
      },
      builder: (context, state) {
        bool isLoading = state is LoadingAuthState;
        return Scaffold(
          body: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextSection(context),
                  const SizedBox(height: 8),
                  _buildLaterButton(context),
                  const SizedBox(height: 8),
                  _buildEnableButton(context, isLoading),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary.withAlpha(30),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.enableNotificationsTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.enableNotificationsBody,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLaterButton(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                _navigateToAccountMiddlePoint(context);
              },
              child: Text(
                AppLocalizations.of(context)!.later,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnableButton(BuildContext context, bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(150),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () async {
                if (context.mounted) {
                  context.read<AuthBloc>().add(StoreFcmTokenEvent());
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  isLoading
                      ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Colors.white,
                        ),
                      )
                      : SizedBox(),
                  Text(
                    AppLocalizations.of(context)!.enable,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
