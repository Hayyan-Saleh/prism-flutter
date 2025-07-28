class ApiEndpoints {
  //TODO: change this line to your own vm
  // static const String baseUrl = 'http://192.168.1.100:8000/api';
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
  static const String blockedUsers = '$usersPrefix/blocked-users';
  static const String likes = '/likes';
  static const String likers = '/likes/users';
  static const String followers = "followers";
  static const String following = "following";

  static const String followUser = "$usersPrefix/followUser";
  static const String unfollow = "unfollow";

  static const String groups = '/groups';
  static const String myOwnedGroups = '$groups/my-owned-groups';
  static const String myFollowedGroups = '$groups/my-groups';
  static const String exploreGroups = '$groups/explore-groups';

  //! statuses
  static const String getFollowingWithStatus = "/followingWithStatus";
  static const String getUserStatuses = "/statuses";
  static const String createStatus = "/statuses";
  static const String archivedStatuses = '/statuses/archived-statuses';

  //! highlights
  static const String highlights = "/highlights";
  static const String setHighlightCover = "/highlights/set-cover";

  // ! nofiticaiton
  static const String getFollowRequests = "$usersPrefix/requests";
  static const String respondToFollowRequest = "$usersPrefix/follow/request";
}
