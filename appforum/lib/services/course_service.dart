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
      throw Exception('Failed to load courses, login');
    }
  }

//delete course
  Future<void> deleteCourse(int courseId) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('course doesnt exist');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.courseAPI}/$courseId');

    var response = await http.delete(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete course');
    }
  }

//update course
  Future<void> editCourse(int courseId, CourseModel model) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.courseAPI}/$courseId');

    var response = await http.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to edit course');
    }
  }

//add Course
  Future<String> addCourse(CourseModel model) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, Config.courseAPI);

    var response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return response.body;
  }

// get course
  Future<CourseModel> getCourseDetails(int courseId) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.courseAPI}/$courseId');

    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    return courseModel(response.body);
  }

  Future<CourseModel> searchCourse(String query) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('Utilisateur non connecté');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.courseAPI}/search');

    var response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({'name': query}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null &&
          jsonResponse is List<dynamic> &&
          jsonResponse.isNotEmpty) {
        final courseData = jsonResponse[0];
        CourseModel course = CourseModel.fromJson(courseData);
        return course;
      } else {
        throw Exception('Aucun cours trouvé');
      }
    } else {
      throw Exception('Échec de la recherche du cours');
    }
  }

  Future<bool> checkCourseExists(CourseModel model) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, Config.courseAPI);

    var response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      return false;
    } else if (response.statusCode == 409) {
      return true;
    } else {
      throw Exception('Failed to check course existence');
    }
  }
}
