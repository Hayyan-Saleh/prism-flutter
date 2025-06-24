import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/sevices/assets.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/app_text_button.dart';
import 'package:prism/core/util/widgets/custom_text_form_field.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/core/util/validators/email_validator.dart';
import 'package:prism/core/util/validators/password_validator.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmail() {
    if (!_emailFormKey.currentState!.validate() ||
        !_passwordFormKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<AuthBloc>().add(
      PasswordLoginAuthEvent(email: email, password: password),
    );
  }

  void _signInWithGoogle() {
    context.read<AuthBloc>().add(GoogleLoginAuthEvent());
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, AppRoutes.signup);
  }

  void _navigateToResetPassword() {
    Navigator.pushNamed(context, AppRoutes.reset);
  }

  Widget _buildGreeting() {
    return Text(
      AppLocalizations.of(context)!.welcome,
      style: Theme.of(
        context,
      ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildIllustration(double height) {
    return SvgPicture.asset(Assets.login, height: 0.25 * height);
  }

  Widget _buildTitle1() {
    return Text(
      AppLocalizations.of(context)!.signinToYourAccount,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  List<Widget> _buildPasswordAuthSection(bool isLoading) {
    return [
      CustomTextFormField(
        formkey: _emailFormKey,
        obsecure: false,
        textEditingController: _emailController,
        errorMessage: AppLocalizations.of(context)!.emailRequired,
        hintText: AppLocalizations.of(context)!.emailRequired,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.emailRequired;
          }
          if (!EmailValidator.isValid(value)) {
            return AppLocalizations.of(context)!.validEmailErrMsg;
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      CustomTextFormField(
        formkey: _passwordFormKey,
        obsecure: true,
        textEditingController: _passwordController,
        errorMessage: AppLocalizations.of(context)!.passwordRequired,
        hintText: AppLocalizations.of(context)!.passwordRequired,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.passwordRequired;
          }
          if (!PasswordValidator.isValid(value)) {
            return AppLocalizations.of(context)!.validPasswordErrMsg;
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      Align(
        alignment: Alignment.centerRight,
        child: AppTextButton(
          text: AppLocalizations.of(context)!.forgotPassword,
          onPressed: isLoading ? () {} : _navigateToResetPassword,
        ),
      ),
      const SizedBox(height: 24),
      AppButton(
        bgColor: Theme.of(context).colorScheme.onPrimary,
        fgColor: Theme.of(context).colorScheme.primary,
        onPressed: isLoading ? () {} : _signInWithEmail,
        child:
            isLoading
                ? SizedBox(
                  height: 32,
                  child: Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                )
                : SizedBox(
                  height: 32,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.signIn,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
      ),
    ];
  }

  Widget _buildSeperator() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(AppLocalizations.of(context)!.or),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGoogleAuthBtn(bool isLoading) {
    return AppButton(
      onPressed: isLoading ? () {} : _signInWithGoogle,
      bgColor: Theme.of(context).colorScheme.onPrimary,
      fgColor: Theme.of(context).colorScheme.primary,
      child:
          isLoading
              ? Icon(Icons.not_interested_rounded)
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.google),
                  const SizedBox(width: 16),
                  Text(
                    AppLocalizations.of(context)!.signInWithGoogle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildSignupNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.dontHaveAccount),
        const SizedBox(width: 4),
        AppTextButton(
          text: AppLocalizations.of(context)!.signUp,
          onPressed: _navigateToSignUp,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = getHeight(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedInAuthState) {
          BlocProvider.of<PAccountBloc>(
            context,
          ).add(DefinePAccountCurrentStateEvent());
          Navigator.pushReplacementNamed(context, AppRoutes.accMiddlePoint);
        } else if (state is FailedAuthState) {
          showCustomAboutDialog(
            context,
            AppLocalizations.of(context)!.error,
            state.failure.message,
            null,
            true,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoadingAuthState;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 16),
                  _buildIllustration(height),
                  const SizedBox(height: 32),
                  _buildTitle1(),
                  const SizedBox(height: 32),
                  ..._buildPasswordAuthSection(isLoading),
                  const SizedBox(height: 16),
                  _buildSeperator(),
                  const SizedBox(height: 16),
                  _buildGoogleAuthBtn(isLoading),
                  const SizedBox(height: 32),
                  _buildSignupNav(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
