import 'dart:convert';
import 'package:appforum/models/user_model.dart';
import 'package:appforum/services/shared_service.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class UserService {
  final String baseUrl = Config.apiUrl;

  UserService();

// liste des users
  Future<List<UserModel>> getUsers() async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('users not found');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, Config.listUser);

    var response = await http.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final users = (jsonResponse as List<dynamic>)
          .map((user) => UserModel.fromJson(user))
          .toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  // get course
  Future<UserModel> getUserDetails(int userId) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.userAPI}/$userId');

    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    return userModel(response.body);
  }

  Future<void> editUser(int userId, UserModel model) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.userAPI}/$userId');

    var response = await http.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    print(response.body);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to edit user');
    }
  }

  Future<void> editUserAdmin(int userId, UserModel model) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.userAPI}/admin/$userId');

    var response = await http.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to edit user');
    }
  }

  Future<void> deleteUser(int userId) async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('course doesnt exist');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(Config.apiUrl, '${Config.userAPI}/$userId');

    var response = await http.delete(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to delete user');
    }
  }
}
