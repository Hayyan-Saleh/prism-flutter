class ApiEndpoints {
  //TODO: change this line to your own vm
  // static const String baseUrl = 'http://192.168.235.11:8000/api';
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String googleLogin = '$baseUrl/auth/google/token';
  static const String sendVerificationCode = '$baseUrl/request-code';
  static const String verifyCode = '$baseUrl/verify-code';
  static const String logout = '$baseUrl/logout';
  static const String verifyResetCode = '$baseUrl/verify-reset-code';
  static const changePassword = '$baseUrl/user/changePassword';
  static const String requestChangeEmailCode =
      "$baseUrl/user/request-change-email-code";
  static const String verifyChangeEmailCode =
      "$baseUrl/user/verify-change-email-code";
}
