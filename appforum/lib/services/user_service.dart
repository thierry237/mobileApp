import 'dart:convert';
import 'package:appforum/models/user_model.dart';
import 'package:appforum/services/shared_service.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class UserService {
  final String baseUrl = Config.apiUrl;

  UserService();

// liste des cours
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
}
