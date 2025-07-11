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
  static const String usersPrefix = "/users";

  // ! personal
  static const String checkUserName = "/user/check-username";
  static const String fetchUserAccount = "/user";
  static const String updatePersonalAccount = "/user/update";
  static const String deletePersonalAccount = "/user/delete";
  static const String blockOtherUser = "$usersPrefix/block";
  static const String unblockOtherUser = "$usersPrefix/unblock";

  // TODO:
  static const String getFollowingWithStatus = "/followingWithStatus";
  static const String getUserStatuses =
      "/statuses"; //body : user_id //! gets the user's statuses (all - no pagination)

  static const String createStatus = "/statuses";

  static const String followUser = "$usersPrefix/followUser";
  static const String unfollow = "unfollow";
  static const String followers = "followers";
  static const String following = "following";

  static const String getFollowRequests = "$usersPrefix/requests";
  static const String respondToFollowRequest = "$usersPrefix/follow/request";

  //? accept user follow request: users/requests/{{request_id}/accept
  //* type: POST
  //  body: targetId
  //? get all follow requests : /users/requests
  //* type: GET
}
