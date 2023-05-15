import 'dart:convert';

PostModel postModel(String str) => PostModel.fromJson(json.decode(str));

class PostModel {
  PostModel({
    this.idPost,
    required this.title,
    required this.message,
    this.createdAt,
    this.idUser,
    this.idCourse,
  });

  late final int? idPost;
  late final String title;
  late final String message;
  late final String? createdAt;
  late final int? idUser;
  late final int? idCourse;

  PostModel.fromJson(Map<String, dynamic> json) {
    idPost = json['idPost'];
    title = json['title'];
    message = json['message'];
    createdAt = json['createdAt'];
    idUser = json['idUser'];
    idCourse = json['idCourse'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idPost'] = idPost;
    data['title'] = title;
    data['message'] = message;
    data['createdAt'] = createdAt;
    data['idUser'] = idUser;
    data['idCourse'] = idCourse;
    return data;
  }
}
