import 'app_failure.dart';

class AuthFailure extends AppFailure {
  AuthFailure(super.message);
}

class EmailNotVerifiedAuthFailure extends AuthFailure {
  EmailNotVerifiedAuthFailure(super.message);
}

class WrongEmailOrPasswordAuthFailure extends AuthFailure {
  WrongEmailOrPasswordAuthFailure(super.message);
}
