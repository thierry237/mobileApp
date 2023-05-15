import 'dart:convert';
import 'package:appforum/services/shared_service.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/comment_model.dart';

class CommentService {
  final String baseUrl = Config.apiUrl;

  CommentService();

// liste des cours
  Future<List<CommentModel>> getComments(int postId) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('Posts not found');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(
        Config.apiUrl, Config.postAPI + '/$postId' + Config.listComment);

    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final comments = (jsonResponse as List<dynamic>)
          .map((comment) => CommentModel.fromJson(comment))
          .toList();
      return comments;
    } else {
      throw Exception('Failed to load Post, login');
    }
  }

//delete course
  Future<void> deleteComment(int commentId) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('course doesnt exist');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.commentAPI}/$commentId');

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
  Future<void> editComment(int commentId, CommentModel model) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.commentAPI}/$commentId');

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
  Future<String> addComment(CommentModel model) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('not authorized');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, Config.commentAPI);
    var response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    print(response.body);
    return response.body;
  }

// get course
  Future<CommentModel> getCommentDetails(int commentId) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.commentAPI}/$commentId');

    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    return commentModel(response.body);
  }
}
