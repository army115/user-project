import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Login{
  Login();
  
  Future<http.Response> doLogin(String username, String password) async {
    String url = '${Connectapi().domain}/login';
    var body = {
      "username": username,
      "password": password,
    };

    return http.post(Uri.parse(url), body: body);
  }

}
