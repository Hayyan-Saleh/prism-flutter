class User {
  final int id;
  final String email;
  final String authType;
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.email,
    required this.authType,
    required this.isEmailVerified,
  });
}
