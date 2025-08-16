part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

//* load_user_use_case
final class DefineAuthCurrentStateEvent extends AuthEvent {}

//* register_user_use_case
final class SignUpAuthEvent extends AuthEvent {
  final String email, password;

  const SignUpAuthEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

//* login_user_use_case
final class PasswordLoginAuthEvent extends AuthEvent {
  final String email, password;

  const PasswordLoginAuthEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

//* google_sign_in_use_case
final class GoogleLoginAuthEvent extends AuthEvent {}

//* verify_email_use_case
final class VerifyEmailAuthEvent extends AuthEvent {
  final String email, code;
  final bool needLogin;

  const VerifyEmailAuthEvent({
    required this.email,
    required this.code,
    required this.needLogin,
  });

  @override
  List<Object> get props => [email, code];
}

//* change_password_use_case
final class ChangePasswordAuthEvent extends AuthEvent {
  final String oldPassword, newPassword;

  const ChangePasswordAuthEvent({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [oldPassword, newPassword];
}

//* logout_use_case
final class LogoutAuthEvent extends AuthEvent {}

//* request_change_email_code_use_case
//? send the code to old email
final class SendChangeEmailCodeAuthEvent extends AuthEvent {}

//* verify_change_email_code_use_case
//? send the code to new email and verify old email
final class ChangeEmailCodeAuthEvent extends AuthEvent {
  final String newEmail, code;
  const ChangeEmailCodeAuthEvent({required this.newEmail, required this.code});

  @override
  List<Object> get props => [newEmail, code];
}

//* send_email_code_use_case
//? send a code to email
final class SendEamilCodeAuthEvent extends AuthEvent {
  final String email;
  final bool isReset;
  const SendEamilCodeAuthEvent({required this.email, required this.isReset});

  @override
  List<Object> get props => [email];
}

//* verify_reset_code_use_case
//? verify reset password code
final class ResetPasswordAuthEvent extends AuthEvent {
  final String email, code, newPassword;
  const ResetPasswordAuthEvent({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  @override
  List<Object> get props => [email, code, newPassword];
}
