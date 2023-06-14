import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:recruitmentclient/models/user.dart';

import '../models/user_request.dart';
import '../providers/auth.dart';

class API {

  static String base = "http://192.168.0.19:7122";
  static String api = "$base/api";


  static Uri loginPath = Uri.parse("$api/authenticate/login");


  static Future<Response> login(UserRequestModel userModel) async {
    return await http.Client()
        .post(loginPath, headers: AuthProvider.getHeaders(), body: jsonEncode(userModel));
  }


}