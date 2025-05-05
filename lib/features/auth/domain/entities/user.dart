enum AuthType { password, google }

class UserEntity {
  final String? email;
  final String token;
  final AuthType authType;

  const UserEntity({
    required this.email,
    required this.token,
    required this.authType,
  });
}
