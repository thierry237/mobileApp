import 'dart:convert';

CourseModel courseModel(String str) => CourseModel.fromJson(json.decode(str));

class CourseModel {
  CourseModel({
    this.idCourse,
    required this.name,
    required this.description,
    this.createdAt,
  });
  late final int? idCourse;
  late final String name;
  late final String description;
  late final String? createdAt;

  CourseModel.fromJson(Map<String, dynamic> json) {
    idCourse = json['idCourse'];
    name = json['name'];
    description = json['description'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idCourse'] = idCourse;
    data['name'] = name;
    data['description'] = description;
    data['createdAt'] = createdAt;
    return data;
  }
}
