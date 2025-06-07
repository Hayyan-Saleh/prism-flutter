import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:realmo/core/errors/failures/app_failure.dart';
import 'package:realmo/core/errors/failures/auth_failure.dart';
import 'package:realmo/features/auth/domain/entities/user_entity.dart';
import 'package:realmo/features/auth/domain/usecases/change_password_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/google_sign_in_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/load_user_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/logout_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/register_user_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/request_change_email_code_usecase.dart';
import 'package:realmo/features/auth/domain/usecases/send_email_code_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/verify_change_email_code_usecase.dart';
import 'package:realmo/features/auth/domain/usecases/verify_email_use_case.dart';
import 'package:realmo/features/auth/domain/usecases/verify_reset_code_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoadUserUseCase loadUser;
  final RegisterUserUseCase registerUser;
  final LoginUserUseCase passwordLogin;
  final GoogleSignInUseCase googleLogin;
  final VerifyEmailUseCase verifyEmail;
  final ChangePasswordUseCase changePassword;
  final LogoutUseCase logout;
  final RequestChangeEmailCodeUseCase sendChangeEmailCode;
  final VerifyChangeEmailCodeUseCase verifyChangeEmailCode;
  final VerifyResetCodeUseCase verifyResetCode;
  final SendEmailCodeUseCase sendEmailCode;

  User? user;
  AuthBloc({
    required this.loadUser,
    required this.registerUser,
    required this.passwordLogin,
    required this.googleLogin,
    required this.verifyEmail,
    required this.changePassword,
    required this.logout,
    required this.sendChangeEmailCode,
    required this.verifyChangeEmailCode,
    required this.sendEmailCode,
    required this.verifyResetCode,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is DefineAuthCurrentStateEvent) {
        emit(LoadingAuthState());

        final either = await loadUser();
        User? loadedUser;
        either.fold(
          (failure) => emit(FailedAuthState(failure: failure)),
          (user) => loadedUser = user,
        );
        if (loadedUser == null) {
          emit(LoggedoutAuthState());
          return;
        } else {
          user = loadedUser;
          if (!loadedUser!.isEmailVerified) {
            emit(
              NotVerifiedAuthState(user: loadedUser, email: loadedUser!.email),
            );
            return;
          } else if (loadedUser!.isEmailVerified) {
            emit(LoggedInAuthState(user: loadedUser!));
          }
        }
      } else if (event is SignUpAuthEvent) {
        emit(LoadingAuthState());
        final either = await registerUser(
          email: event.email,
          password: event.password,
        );
        either.fold(
          (failure) => emit(FailedAuthState(failure: failure)),
          (_) => emit(NotVerifiedAuthState(email: event.email)),
        );
      } else if (event is PasswordLoginAuthEvent) {
        emit(LoadingAuthState());
        final either = await passwordLogin(
          email: event.email,
          password: event.password,
        );
        either.fold((failure) {
          if (failure is EmailNotVerifiedAuthFailure) {
            emit(NotVerifiedAuthState(email: event.email));
          } else {
            emit(FailedAuthState(failure: failure));
          }
        }, (user) => emit(LoggedInAuthState(user: user)));
      } else if (event is GoogleLoginAuthEvent) {
        emit(LoadingAuthState());
        final either = await googleLogin();
        either.fold(
          (failure) => emit(FailedAuthState(failure: failure)),
          (user) => emit(LoggedInAuthState(user: user)),
        );
      } else if (event is VerifyEmailAuthEvent) {
        emit(LoadingAuthState());
        final either = await verifyEmail(email: event.email, code: event.code);
        either.fold(
          (failure) => emit(FailedAuthState(failure: failure)),
          (_) => emit(VerifiedAuthState(needLogin: event.needLogin)),
        );
      } else if (event is ChangePasswordAuthEvent) {
        emit(LoadingAuthState());
        final either = await changePassword(
          newPassword: event.newPassword,
          oldPassword: event.oldPassword,
        );
        either.fold(
          (failure) => emit(FailedAuthState(failure: failure)),
          (_) => emit(DoneChangePasswordAuthState()),
        );
      } else if (event is LogoutAuthEvent) {
        emit(LoadingAuthState());
        final either = await logout();
        either.fold((failure) => emit(FailedAuthState(failure: failure)), (_) {
          user = null;
          emit(LoggedoutAuthState());
        });
      } else if (event is SendChangeEmailCodeAuthEvent) {
        emit(LoadingAuthState());
        final either = await sendChangeEmailCode();
        either.fold(
          (failure) => emit(FailedAuthState(failure: failure)),
          (_) => emit(DoneAuthState()),
        );
      } else if (event is ChangeEmailCodeAuthEvent) {
        emit(LoadingAuthState());
        final either = await verifyChangeEmailCode(
          code: event.code,
          newEmail: event.newEmail,
        );
        either.fold((failure) => emit(FailedAuthState(failure: failure)), (_) {
          emit(NeedVerifyAuthState(email: event.newEmail, user: user));
        });
      } else if (event is SendEamilCodeAuthEvent) {
        emit(LoadingAuthState());
        final either = await sendEmailCode(
          email: event.email,
          isReset: event.isReset,
        );
        either.fold((failure) => emit(FailedAuthState(failure: failure)), (_) {
          event.isReset
              ? emit(DoneAuthState())
              : emit(NotVerifiedAuthState(email: event.email));
        });
      } else if (event is ResetPasswordAuthEvent) {
        emit(LoadingAuthState());
        final either = await verifyResetCode(
          code: event.code,
          email: event.email,
          newPassword: event.newPassword,
        );
        either.fold((failure) => emit(FailedAuthState(failure: failure)), (_) {
          emit(DoneAuthState());
        });
      }
    });
  }
}
