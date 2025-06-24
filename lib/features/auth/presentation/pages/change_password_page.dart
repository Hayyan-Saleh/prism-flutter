import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/custom_text_form_field.dart';
import 'package:prism/core/util/validators/password_validator.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordFormKey = GlobalKey<FormState>();
  final _newPasswordFormKey = GlobalKey<FormState>();
  final _confirmNewPasswordFormKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Widget _buildTitle1(String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: [
        CustomTextFormField(
          formkey: _oldPasswordFormKey,
          obsecure: true,
          textEditingController: _oldPasswordController,
          errorMessage: AppLocalizations.of(context)!.oldPasswordRequired,
          hintText: AppLocalizations.of(context)!.oldPasswordRequired,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.oldPasswordRequired;
            }
            if (!PasswordValidator.isValid(value)) {
              return AppLocalizations.of(context)!.validPasswordErrMsg;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          formkey: _newPasswordFormKey,
          obsecure: true,
          textEditingController: _newPasswordController,
          errorMessage: AppLocalizations.of(context)!.newPasswordRequired,
          hintText: AppLocalizations.of(context)!.oldPasswordRequired,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.oldPasswordRequired;
            }
            if (!PasswordValidator.isValid(value)) {
              return AppLocalizations.of(context)!.validPasswordErrMsg;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          formkey: _confirmNewPasswordFormKey,
          obsecure: true,
          textEditingController: _confirmNewPasswordController,
          errorMessage:
              AppLocalizations.of(context)!.confirmNewPasswordRequired,
          hintText: AppLocalizations.of(context)!.confirmNewPasswordRequired,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.confirmNewPasswordRequired;
            }
            if (_confirmNewPasswordController.text.trim() !=
                _newPasswordController.text.trim()) {
              return AppLocalizations.of(context)!.passwordsDontMatch;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildChangePasswordBtn(bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: AppButton(
              onPressed:
                  isLoading
                      ? () {}
                      : () {
                        if (_oldPasswordFormKey.currentState!.validate() ||
                            _newPasswordFormKey.currentState!.validate() ||
                            _confirmNewPasswordFormKey.currentState!
                                .validate()) {
                          final String oldPassword =
                              _oldPasswordController.text.trim();
                          final String newPassword =
                              _newPasswordController.text.trim();

                          context.read<AuthBloc>().add(
                            ChangePasswordAuthEvent(
                              oldPassword: oldPassword,
                              newPassword: newPassword,
                            ),
                          );
                        }
                      },
              child:
                  isLoading
                      ? SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                      : Text(
                        AppLocalizations.of(context)!.changePassword,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is DoneChangePasswordAuthState) {
          Navigator.of(context).pop();
          showCustomAboutDialog(
            context,
            AppLocalizations.of(context)!.success,
            AppLocalizations.of(context)!.passwordChanged,
            null,
            true,
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is LoadingAuthState;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.changePassword,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTitle1(AppLocalizations.of(context)!.changeYourPassword),
                _buildTextFields(),
                _buildChangePasswordBtn(isLoading),
              ],
            ),
          ),
        );
      },
    );
  }
}
