import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.idUser,
    required this.isAdmin,
    required this.username,
    required this.token,
  });
  late final int idUser;
  late final bool isAdmin;
  late final String username;
  late final String token;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    isAdmin = json['isAdmin'];
    username = json['username'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idUser'] = idUser;
    data['isAdmin'] = isAdmin;
    data['username'] = username;
    data['token'] = token;
    return data;
  }
}
