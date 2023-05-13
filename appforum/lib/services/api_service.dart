import 'dart:convert';

import 'package:appforum/services/shared_service.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiUrl, Config.loginAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      await SharedService.setLoginDetails((loginResponseJson(response.body)));
      return true;
    } else {
      return false;
    }
  }

  static Future<RegisterResponseModel> register(
      RegisterRequestModel model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.http(Config.apiUrl, Config.registerAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    return registerResponseModel(response.body);
  }

  static Future<String> getUser() async {
    var loginDetails = await SharedService.loginDetails();
    if (loginDetails == null) {
      throw Exception('User not logged in $loginDetails');
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails.token}'
    };

    var url = Uri.http(
      Config.apiUrl,
      Config.userProfileAPI
          .replaceAll(":idUser", loginDetails.idUser.toString()),
    );

    var response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get user details');
    }
  }
}
