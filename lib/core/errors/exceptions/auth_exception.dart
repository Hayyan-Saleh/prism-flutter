import 'app_exception.dart';

class AuthException extends AppException {
  AuthException(super.message);
}

class EmailNotVerifiedAuthException extends AuthException {
  EmailNotVerifiedAuthException(super.message);
}

class WrongEmailOrPasswordAuthException extends AuthException {
  WrongEmailOrPasswordAuthException(super.message);
}

class ExpiredCodeAuthException extends AuthException {
  ExpiredCodeAuthException(super.message);
}
