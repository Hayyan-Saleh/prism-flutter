class ApiEndpoints {
  //TODO: change this line to your own vm

  static const physicalDomain = '192.168.1.33';
  static const virtualDomain = '10.0.2.2';
  static const String coreBaseUrl = 'http://$physicalDomain:8000/api';
  static const String liveStreamBaseUrl = 'http://$physicalDomain:4000/api';
  static const String liveStreamSocketUrl = 'ws://$physicalDomain:4000';

  //! auth

  static const String register = '$coreBaseUrl/register';
  static const String login = '$coreBaseUrl/login';
  static const String googleLogin = '$coreBaseUrl/auth/google/token';
  static const String sendVerificationCode = '$coreBaseUrl/request-code';
  static const String verifyCode = '$coreBaseUrl/verify-code';
  static const String logout = '$coreBaseUrl/logout';
  static const String verifyResetCode = '$coreBaseUrl/verify-reset-code';
  static const changePassword = '$coreBaseUrl/user/changePassword';
  static const String requestChangeEmailCode =
      "$coreBaseUrl/user/request-change-email-code";
  static const String verifyChangeEmailCode =
      "$coreBaseUrl/user/verify-change-email-code";

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

  //! live-stream
  static const String stream = '/stream';
  static const String startStream = '$stream/start';
  static String endStream(String streamKey) => '$stream/end/$streamKey';
}
