import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:recruitmentclient/models/user.dart';

import '../models/candidate.dart';
import '../models/user_request.dart';
import '../providers/auth.dart';

class API {
  static String base = "http://192.168.0.19:7122";
  static String api = "$base/api";

  static Uri loginPath = Uri.parse("$api/authenticate/login");
  static Uri usersPath = Uri.parse("$api/users");
  static Uri getManagersPath = Uri.parse("$api/users/managers");
  static Uri uploadCandidatesPath = Uri.parse("$api/candidates/upload");
  static Uri acceptCandidatesPath = Uri.parse("$api/candidates/accept");
  static Uri findBestMatchesPath = Uri.parse("$api/matching/offer");
  //exclude managers and superadmin
  static Uri getUsersPath = Uri.parse("$api/users/users");

  static Future<Response> login(UserRequestModel userModel) async {
    return await http.Client().post(loginPath,
        headers: AuthProvider.getHeaders(), body: jsonEncode(userModel));
  }

  // USERS
  static Future<Response> createUser(UserModel userModel) async {
    return await http.Client().post(usersPath,
        headers: AuthProvider.getHeaders(), body: jsonEncode(userModel));
  }

  static Future<Response> updateUser(UserModel userModel) async {
    return await http.Client().put(usersPath,
        headers: AuthProvider.getHeaders(), body: jsonEncode(userModel));
  }

  static Future<Response> deleteUser(String username) async {
    /* final Map<String, dynamic> body = {
    'username': username,
  };*/
    return await http.Client().delete(usersPath,
        headers: AuthProvider.getHeaders(), body: jsonEncode(username));
  }

  static Future<Response> getManagers() async {
    return await http.Client()
        .get(getManagersPath, headers: AuthProvider.getHeaders());
  }

  static Future<Response> getUsers() async {
    return await http.Client()
        .get(getUsersPath, headers: AuthProvider.getHeaders());
  }

  //Candidates
  static Future<Response> uploadCandidates(List<String> filesPaths) async {
    final request = http.MultipartRequest('POST', uploadCandidatesPath);
    request.headers.addAll(AuthProvider.getHeaders());

    for (var path in filesPaths) {
      request.files.add(await http.MultipartFile.fromPath('files', path));
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  static Future<Response> acceptCandidates(List<Candidate> candidates) async {
    var jsonToEncode = candidates.map((activity) => activity).toList();
    return await http.Client().post(acceptCandidatesPath,
        headers: AuthProvider.getHeaders(), body: jsonEncode(jsonToEncode));
  }

  //Offers
  static Future<Response> findBestMatches(String offerContent) async {
    return await http.Client().post(findBestMatchesPath,
        headers: AuthProvider.getHeaders(), body: jsonEncode(offerContent));
  }
}
