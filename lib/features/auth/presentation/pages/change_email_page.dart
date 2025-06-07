import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realmo/core/util/general/app_routes.dart';
import 'package:realmo/core/util/widgets/app_button.dart';
import 'package:realmo/core/util/widgets/app_text_button.dart';
import 'package:realmo/core/util/widgets/custom_text_form_field.dart';
import 'package:realmo/features/auth/domain/validators/email_validator.dart';
import 'package:realmo/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:realmo/features/auth/presentation/widgets/code_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final GlobalKey<FormState> _newEmailFormKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();

  final int _codeLength = 4;

  String? _sendDate;

  bool isCodeResent = false;

  @override
  initState() {
    super.initState();
    _sendVerificationCode();
  }

  void _changeEmail() {
    final String code = _codeController.text.trim();
    if (_newEmailFormKey.currentState!.validate() && code.isNotEmpty) {
      final String newEmail = _newEmailController.text.trim();
      context.read<AuthBloc>().add(
        ChangeEmailCodeAuthEvent(newEmail: newEmail, code: code),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  void _setSendDate() {
    final date = DateTime.now();
    _sendDate = "${date.hour}:${date.minute}";
  }

  void _sendVerificationCode() {
    context.read<AuthBloc>().add(SendChangeEmailCodeAuthEvent());
    _setSendDate();
  }

  Widget _buildInfo() {
    return Text(
      "${AppLocalizations.of(context)!.verificationInfoOld}${_sendDate != null ? 'at $_sendDate' : 'recently'}",
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

  Widget _buildTitle2(String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSendBtn() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: AppButton(
              onPressed: _changeEmail,
              child: Text(
                AppLocalizations.of(context)!.changeEmail,
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

  Widget _buildResendCodeBtn() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
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
                      _sendVerificationCode();
                      isCodeResent = true;
                    },
                    text: AppLocalizations.of(context)!.resendVerificationCode,
                  ),
                ],
              ),
            );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.changeEmail,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedInAuthState && !isCodeResent) {
          _sendVerificationCode();
        } else if (state is NeedVerifyAuthState) {
          Navigator.pushReplacementNamed(context, AppRoutes.verification);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is LoadingAuthState;
        return Scaffold(
          appBar: _buildAppBar(),
          body:
              isLoading
                  ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                  : Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(),
                          SizedBox(),

                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 40,
                              children: [
                                _buildInfo(),
                                _buildTitle2("Enter Verification Code"),
                                CodeWidget(
                                  length: _codeLength,
                                  controller: _codeController,
                                ),
                                _buildTitle2("Add new Email"),
                                CustomTextFormField(
                                  formkey: _newEmailFormKey,
                                  obsecure: false,
                                  textEditingController: _newEmailController,
                                  errorMessage:
                                      AppLocalizations.of(
                                        context,
                                      )!.newEmailRequired,
                                  hintText:
                                      AppLocalizations.of(
                                        context,
                                      )!.newEmailRequired,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(
                                        context,
                                      )!.newEmailRequired;
                                    }
                                    if (!EmailValidator.isValid(value)) {
                                      return AppLocalizations.of(
                                        context,
                                      )!.newEmailValid;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(),
                                _buildSendBtn(),
                              ],
                            ),
                          ),
                          SizedBox(),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 96.0,
                                  vertical: 32,
                                ),

                                child: Divider(thickness: 3),
                              ),
                              _buildNote(),
                              SizedBox(height: 8),
                              _buildResendCodeBtn(),
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
