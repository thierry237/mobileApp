import 'dart:convert';

UserModel userModel(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  UserModel({
    required this.idUser,
    required this.lastname,
    required this.firstname,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
  });
  late final int idUser;
  late final String lastname;
  late final String firstname;
  late final String username;
  late final String email;
  late final String password;
  late final String createdAt;

  UserModel.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    lastname = json['lastname'];
    firstname = json['firstname'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idUser'] = idUser;
    data['lastname'] = lastname;
    data['firstname'] = firstname;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['createdAt'] = createdAt;
    return data;
  }
}
