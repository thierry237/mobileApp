import 'dart:convert';

UserModel userModel(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  UserModel({
    this.idUser,
    this.lastname,
    this.firstname,
    this.username,
    this.email,
    this.password,
    this.createdAt,
    this.isAdmin,
  });
  late final int? idUser;
  late final String? lastname;
  late final String? firstname;
  late final String? username;
  late final String? email;
  late final String? password;
  late final String? createdAt;
  late final bool? isAdmin;

  UserModel.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    lastname = json['lastname'];
    firstname = json['firstname'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    createdAt = json['createdAt'];
    isAdmin = json['isAdmin'];
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
    data['isAdmin'] = isAdmin;
    return data;
  }
}
