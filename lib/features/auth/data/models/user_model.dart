import '../../domain/entities/user_entity.dart';

class UserModel extends User {
  final String? token;

  const UserModel({
    required super.id,
    required super.email,
    required super.authType,
    this.token,
    required super.isEmailVerified,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    required String authType,
    required bool isEmailVerified,
  }) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      authType: authType,
      token: json['token'],
      isEmailVerified: isEmailVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'authType': authType,
      if (token != null) 'token': token,
      'is_email_verified': isEmailVerified,
    };
  }
}
