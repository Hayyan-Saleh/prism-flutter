import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/general/app_routes.dart';
import 'package:prism/core/util/general/assets.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/app_text_button.dart';
import 'package:prism/core/util/widgets/custom_text_form_field.dart';
import 'package:prism/features/auth/domain/validators/email_validator.dart';
import 'package:prism/features/auth/domain/validators/password_validator.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';
import 'package:prism/features/auth/presentation/widgets/code_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _confirmPasswordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _currentPage = 0;
  final int _pagesNum = 3;
  final PageController _pageController = PageController();

  bool isCodeResent = false;
  bool allowMove = true;
  late final String email;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  _moveNext() {
    _pageController.animateToPage(
      ++_currentPage,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  void _resendCode() {
    context.read<AuthBloc>().add(
      SendEamilCodeAuthEvent(email: email, isReset: true),
    );
    isCodeResent = true;
    allowMove = false;
  }

  void _sendVerificationCode() {
    if (_emailFormKey.currentState!.validate()) {
      email = _emailController.text.trim();
      context.read<AuthBloc>().add(
        SendEamilCodeAuthEvent(email: email, isReset: true),
      );
    }
  }

  void _resetPassword() {
    if (_passwordFormKey.currentState!.validate() &&
        _confirmPasswordFormKey.currentState!.validate()) {
      allowMove = true;
      final code = _verificationCodeController.text.trim();
      final password = _passwordController.text.trim();
      context.read<AuthBloc>().add(
        ResetPasswordAuthEvent(code: code, email: email, newPassword: password),
      );
    }
  }

  void _navigateToSignIn() {
    Navigator.pushReplacementNamed(context, AppRoutes.signin);
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.resetPassword,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildTitle1(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _getLoadingIndicator() {
    return SizedBox(
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
    );
  }

  Widget _buildVerifyEmailBtn(bool isLoading) {
    return AppButton(
      bgColor: Theme.of(context).colorScheme.onPrimary,
      fgColor: Theme.of(context).colorScheme.primary,
      onPressed: _sendVerificationCode,
      child:
          isLoading
              ? _getLoadingIndicator()
              : Text(
                AppLocalizations.of(context)!.sendVerificationCode,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }

  Widget _buildResetBtn(bool isLoading) {
    return AppButton(
      bgColor: Theme.of(context).colorScheme.onPrimary,
      fgColor: Theme.of(context).colorScheme.primary,
      onPressed: _resetPassword,
      child:
          isLoading
              ? _getLoadingIndicator()
              : Text(
                AppLocalizations.of(context)!.resetPassword,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }

  Widget _buildResendCodeBtn(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: AppTextButton(
        onPressed: isLoading ? () {} : _resendCode,
        text: AppLocalizations.of(context)!.resendVerificationCode,
      ),
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

  Widget _buildSigninNavBtn(bool isLoading) {
    return AppButton(
      onPressed: _navigateToSignIn,
      bgColor: Theme.of(context).colorScheme.onPrimary,
      fgColor: Theme.of(context).colorScheme.primary,
      child:
          isLoading
              ? _getLoadingIndicator()
              : Text(
                AppLocalizations.of(context)!.goBackToSignIn1,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }

  Widget _buildIndicators() {
    final double width = getWidth(context);
    return Center(
      child: SizedBox(
        width: 0.4 * width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_pagesNum, (index) {
            final bool isCurrent = index == _currentPage;
            final Color onPrimaryColor =
                Theme.of(context).colorScheme.onPrimary;
            final Color primaryColor = Theme.of(context).colorScheme.primary;
            if (isCurrent) {
              return Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: onPrimaryColor,
                    radius: 12,
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 8,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return CircleAvatar(backgroundColor: onPrimaryColor, radius: 8);
            }
          }),
        ),
      ),
    );
  }

  Widget _buildConfirmationText() {
    return Text(
      AppLocalizations.of(context)!.doneResendCode,
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildPage1(double height, bool isLoading) {
    return Center(
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTitle1(AppLocalizations.of(context)!.enterEmailToVerify),
                const SizedBox(height: 32),
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
                const SizedBox(height: 24),
                Row(
                  children: [Expanded(child: _buildVerifyEmailBtn(isLoading))],
                ),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildPage2(double height, bool isLoading) {
    return Center(
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTitle1(AppLocalizations.of(context)!.addVerificationCode),
                const SizedBox(height: 32),
                CodeWidget(length: 4, controller: _verificationCodeController),
                const SizedBox(height: 32),
                _buildTitle1(AppLocalizations.of(context)!.addNewPassword),
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
                  errorMessage:
                      AppLocalizations.of(context)!.confirmPasswordRequired,
                  hintText:
                      AppLocalizations.of(context)!.confirmPasswordRequired,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(
                        context,
                      )!.confirmPasswordRequired;
                    }
                    if (_confirmPasswordController.text.trim() !=
                        _passwordController.text.trim()) {
                      return AppLocalizations.of(context)!.passwordsDontMatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(children: [Expanded(child: _buildResetBtn(isLoading))]),
                const SizedBox(height: 16),
                Divider(thickness: 3),
                const SizedBox(height: 16),
                _buildNote(),
                if (isCodeResent)
                  _buildConfirmationText()
                else
                  _buildResendCodeBtn(isLoading),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildPage3(double height, bool isLoading) {
    return Center(
      child: Column(
        children: [
          Expanded(child: SizedBox()),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTitle1(AppLocalizations.of(context)!.goBackToSignIn2),
                const SizedBox(height: 32),
                SvgPicture.asset(Assets.done, height: 0.25 * height),
                const SizedBox(height: 32),
                Row(children: [Expanded(child: _buildSigninNavBtn(isLoading))]),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = getHeight(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is DoneAuthState && allowMove) {
          _moveNext();
        }
      },
      builder: (context, state) {
        bool isLoading = state is LoadingAuthState;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: _buildAppBar(),
          body: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 0.75 * height,
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPage1(height, isLoading),
                        _buildPage2(height, isLoading),
                        _buildPage3(height, isLoading),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.1 * height, child: _buildIndicators()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
