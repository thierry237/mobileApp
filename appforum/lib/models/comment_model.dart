import 'dart:convert';

CommentModel commentModel(String str) =>
    CommentModel.fromJson(json.decode(str));

class CommentModel {
  CommentModel({
    this.idComment,
    required this.comment,
    this.like = false,
    this.createdAt,
    this.idUser,
    this.idPost,
  });
  late final int? idComment;
  late final String comment;
  late final bool? like;
  late final String? createdAt;
  late final int? idUser;
  late final int? idPost;

  CommentModel.fromJson(Map<String, dynamic> json) {
    idComment = json['idComment'];
    comment = json['comment'];
    like = json['like'];
    createdAt = json['createdAt'];
    idUser = json['idUser'];
    idPost = json['idPost'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idComment'] = idComment;
    data['comment'] = comment;
    data['like'] = like;
    data['createdAt'] = createdAt;
    data['idUser'] = idUser;
    data['idPost'] = idPost;
    return data;
  }
}
