part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class LoadingAuthState extends AuthState {}

final class LoggedoutAuthState extends AuthState {}

final class NotVerifiedAuthState extends AuthState {
  final String email;
  final User? user;
  const NotVerifiedAuthState({required this.email, this.user});
  @override
  List<Object> get props => user == null ? [email] : [email, user!];
}

final class NeedVerifyAuthState extends AuthState {
  final String email;
  final User? user;
  const NeedVerifyAuthState({required this.email, this.user});
  @override
  List<Object> get props => user == null ? [email] : [email, user!];
}

final class VerifiedAuthState extends AuthState {
  final bool needLogin;

  const VerifiedAuthState({required this.needLogin});
  @override
  List<Object> get props => [needLogin];
}

final class LoggedInAuthState extends AuthState {
  final User user;

  const LoggedInAuthState({required this.user});

  @override
  List<Object> get props => [user];
}

final class DoneAuthState extends AuthState {}

final class DoneResetPasswordAuthState extends AuthState {}

final class DoneChangePasswordAuthState extends AuthState {}

final class FailedAuthState extends AuthState {
  final AppFailure failure;

  const FailedAuthState({required this.failure});

  @override
  List<Object> get props => [failure];
}
