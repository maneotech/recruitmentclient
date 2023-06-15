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
  static Uri usersPath = Uri.parse("$api/users");
  static Uri getManagersPath = Uri.parse("$api/users/managers");
  //exclude managers and superadmin
  static Uri getUsersPath = Uri.parse("$api/users/users");

  static Future<Response> login(UserRequestModel userModel) async {
    return await http.Client()
        .post(loginPath, headers: AuthProvider.getHeaders(), body: jsonEncode(userModel));
  }

  // USERS 
 static Future<Response> createUser(UserModel userModel) async {
  var a = jsonEncode(userModel);
    return await http.Client()
        .post(usersPath, headers: AuthProvider.getHeaders(), body: jsonEncode(userModel));
  }

 static Future<Response> getManagers() async {
    return await http.Client()
        .get(getManagersPath, headers: AuthProvider.getHeaders());
  }

 static Future<Response> getUsers() async {
    return await http.Client()
        .get(getUsersPath, headers: AuthProvider.getHeaders());
  } 

}