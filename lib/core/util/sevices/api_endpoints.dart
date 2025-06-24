class ApiEndpoints {
  //TODO: change this line to your own vm
  // static const String baseUrl = 'http://192.168.235.11:8000/api';
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  //! auth

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

  //! account

  // ! personal
  static const String checkUserName = "/user/check-username";
  static const String fetchUserAccount = "/user";
  static const String updatePersonalAccount = "/user/update";

  // TODO:
  static const String usersPrefix = "/users";
  static const String getFollowingWithStatus =
      "$usersPrefix/followingWithStatus ";
  static const String getUserStatuses =
      "$usersPrefix/statuses"; //body : user_id //! gets the user's statuses (all - no pagination)

  static const String followUser = "$usersPrefix/followUser";
  static const String unfollow = "unfollow";
  static const String followers = "followers";
  static const String following = "following";

  //? follow user : users/followUser
  //* type: POST
  //  body: targetId
  //? accept user follow request: users/requests/{{request_id}/accept
  //* type: POST
  //  body: targetId
  //? unfollow user : users/{user_id}/unfollow
  //* type: DELETE
  //? get followers :  /users/{user_id}/followers
  //* type: GET
  //? get following :  /users/{user_id}/following
  //* type: GET
  //? get all follow requests : /users/requests
  //* type: GET
}
