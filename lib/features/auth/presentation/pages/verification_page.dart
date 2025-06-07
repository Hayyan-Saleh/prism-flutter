import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/general/app_routes.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/app_text_button.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:prism/features/auth/presentation/widgets/code_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  final int _codeLength = 4;

  String? _sendDate;

  bool isCodeResent = false;

  @override
  initState() {
    super.initState();
    _setSendDate();
  }

  void _verifyCode(String email) {
    final String code = _codeController.text.trim();
    if (code.isNotEmpty) {
      context.read<AuthBloc>().add(
        VerifyEmailAuthEvent(email: email, code: code, needLogin: true),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _setSendDate() {
    final date = DateTime.now();
    _sendDate = "${date.hour}:${date.minute}";
  }

  void _sendVerificationCode(String email) {
    context.read<AuthBloc>().add(
      SendEamilCodeAuthEvent(email: email, isReset: false),
    );
    _setSendDate();
  }

  Widget _buildInfo(String email) {
    return Text(
      "${AppLocalizations.of(context)!.verificationInfo1}$email ${_sendDate != null ? '${AppLocalizations.of(context)!.verificationInfo2} $_sendDate' : AppLocalizations.of(context)!.recently}",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildNote() {
    return Text.rich(
      TextSpan(
        text: AppLocalizations.of(context)!.note,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.codeValidOneHour,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle1() {
    return Text(
      AppLocalizations.of(context)!.verifyYourEmail,
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSendBtn(String email) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: AppButton(
              onPressed: () => _verifyCode(email),
              child: Text(
                AppLocalizations.of(context)!.verify,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResendCodeBtn(String email) {
    return isCodeResent
        ? Text(
          AppLocalizations.of(context)!.doneResendCode,
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )
        : Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.didntRecieveCode),
              SizedBox(width: 3),
              AppTextButton(
                onPressed: () {
                  _sendVerificationCode(email);
                  isCodeResent = true;
                },
                text: AppLocalizations.of(context)!.resendVerificationCode,
              ),
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is NotVerifiedAuthState && !isCodeResent) {
          _sendVerificationCode(state.email);
        } else if (state is VerifiedAuthState) {
          // TODO: Take to account middle point
          Navigator.pushNamedAndRemoveUntil(
            context,
            state.needLogin ? AppRoutes.signin : AppRoutes.home,
            ModalRoute.withName(AppRoutes.myApp),
          );
        }
      },
      builder: (context, state) {
        String? email;
        final bool isLoading = state is LoadingAuthState;
        if (state is NeedVerifyAuthState) {
          email = state.email;
        } else if (state is NotVerifiedAuthState) {
          email = state.email;
        }
        return Scaffold(
          body:
              isLoading
                  ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                  : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTitle1(),
                          SizedBox(),
                          SizedBox(),

                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              spacing: 50,
                              children: [
                                _buildInfo(email ?? "NOT_DEFINED"),

                                CodeWidget(
                                  length: _codeLength,
                                  controller: _codeController,
                                ),
                                _buildSendBtn(email ?? "NOT_DEFINED"),
                              ],
                            ),
                          ),
                          SizedBox(),
                          SizedBox(),
                          Column(
                            children: [
                              Divider(thickness: 3),
                              SizedBox(height: 32),
                              _buildNote(),
                              SizedBox(height: 8),
                              _buildResendCodeBtn(email ?? "NOT_DEFINED"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
        );
      },
    );
  }
}
