import 'package:store_lyqx/lyqx_core.dart';

class UserModel {
  final int id;
  final String username;
  final String email;

  UserModel({required this.id, required this.username, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
  };

  factory UserModel.fromEntity(UserEntity e) =>
      UserModel(id: e.id, username: e.username, email: e.email);
}
