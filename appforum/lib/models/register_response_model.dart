import 'dart:convert';

RegisterResponseModel registerResponseModel(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

class RegisterResponseModel {
  RegisterResponseModel({
    required this.idUser,
    required this.username,
    required this.isAdmin,
  });
  late final int? idUser;
  late final String? username;
  late final bool? isAdmin;

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    idUser = json['idUser'];
    username = json['username'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idUser'] = idUser;
    data['username'] = username;
    data['isAdmin'] = isAdmin;
    return data;
  }
}
