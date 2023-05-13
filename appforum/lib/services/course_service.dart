import 'dart:convert';
import 'package:appforum/services/shared_service.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/course_model.dart';

class CourseService {
  final String baseUrl = Config.apiUrl;

  CourseService();

// liste des cours
  Future<List<CourseModel>> getCourses() async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('courses not found');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, Config.listCourse);

    var response = await http.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final courses = (jsonResponse as List<dynamic>)
          .map((course) => CourseModel.fromJson(course))
          .toList();
      return courses;
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
