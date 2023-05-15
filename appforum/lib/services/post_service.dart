import 'dart:convert';
import 'package:appforum/services/shared_service.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/post_model.dart';

class PostService {
  final String baseUrl = Config.apiUrl;

  PostService();

// liste des cours
  Future<List<PostModel>> getPosts(int courseId) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('Posts not found');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(
        Config.apiUrl, Config.courseAPI + '/$courseId' + Config.listPost);

    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final posts = (jsonResponse as List<dynamic>)
          .map((post) => PostModel.fromJson(post))
          .toList();
      return posts;
    } else {
      throw Exception('Failed to load Post, login');
    }
  }

//delete course
  Future<void> deletePost(int postId) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('course doesnt exist');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.postAPI}/$postId');

    var response = await http.delete(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete post');
    }
  }

//update course
  Future<void> editPost(int postId, PostModel model) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.postAPI}/$postId');

    var response = await http.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to edit post');
    }
  }

//add Course
  Future<String> addPost(PostModel model) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('not authorized');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, Config.postAPI);

    var response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    return response.body;
  }

// get course
  Future<PostModel> getPostDetails(int postId) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.postAPI}/$postId');

    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    return postModel(response.body);
  }
}
