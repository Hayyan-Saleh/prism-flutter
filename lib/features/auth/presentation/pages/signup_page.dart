import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/sevices/assets.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/app_text_button.dart';
import 'package:prism/core/util/widgets/custom_text_form_field.dart';
import 'package:prism/core/util/validators/email_validator.dart';
import 'package:prism/core/util/validators/password_validator.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _confirmPasswordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_emailFormKey.currentState!.validate() ||
        !_passwordFormKey.currentState!.validate() ||
        !_confirmPasswordFormKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<AuthBloc>().add(
      SignUpAuthEvent(email: email, password: password),
    );
  }

  void _navigateToSignIn() {
    Navigator.pushReplacementNamed(context, AppRoutes.signin);
  }

  Widget _buildGreeting() {
    return Text(
      AppLocalizations.of(context)!.createAccount,
      style: Theme.of(
        context,
      ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildIllustration(double height) {
    return SvgPicture.asset(Assets.signup, height: 0.25 * height);
  }

  Widget _buildTitle1() {
    return Text(
      AppLocalizations.of(context)!.signupToGetStarted,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  List<Widget> _buildPasswordAuthSection() {
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
      CustomTextFormField(
        formkey: _confirmPasswordFormKey,
        obsecure: true,
        textEditingController: _confirmPasswordController,
        errorMessage: AppLocalizations.of(context)!.confirmPasswordRequired,
        hintText: AppLocalizations.of(context)!.confirmPasswordRequired,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.confirmPasswordRequired;
          }
          if (_confirmPasswordController.text.trim() !=
              _passwordController.text.trim()) {
            return AppLocalizations.of(context)!.passwordsDontMatch;
          }
          return null;
        },
      ),
    ];
  }

  Widget _buildSignupBtn(bool isLoading) {
    return AppButton(
      bgColor: Theme.of(context).colorScheme.onPrimary,
      fgColor: Theme.of(context).colorScheme.primary,
      onPressed: isLoading ? () {} : _register,
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
                    AppLocalizations.of(context)!.signUp,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildSigninNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.alreadyHaveAccount),
        const SizedBox(width: 4),
        AppTextButton(
          text: AppLocalizations.of(context)!.signIn,
          onPressed: _navigateToSignIn,
        ),
      ],
    );
  }

  Widget _buildPrivacyPolicy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Center(
        child: Text.rich(
          TextSpan(
            text: AppLocalizations.of(context)!.privacyNote1,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: AppLocalizations.of(context)!.privacyNote2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        showCustomAboutDialog(
                          context,
                          AppLocalizations.of(context)!.prismPrivacyPolicy,
                          AppLocalizations.of(context)!.detailedPolicy,
                          null,
                          true,
                        );
                      },
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = getHeight(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is NotVerifiedAuthState) {
          Navigator.pushReplacementNamed(context, AppRoutes.verification);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is LoadingAuthState;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 0.9 * height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildGreeting(),
                        const SizedBox(height: 32),
                        _buildIllustration(height),
                        const SizedBox(height: 32),
                        _buildTitle1(),
                        const SizedBox(height: 32),
                        ..._buildPasswordAuthSection(),
                        const SizedBox(height: 24),
                        _buildSignupBtn(isLoading),
                      ],
                    ),
                    _buildPrivacyPolicy(),
                    _buildSigninNav(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
