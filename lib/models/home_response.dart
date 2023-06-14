import 'dart:convert';

import 'package:recruitmentclient/models/user.dart';

class HomeResponse {
  String token;
  UserModel user;

  HomeResponse(this.token, this.user);

  factory HomeResponse.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return HomeResponse(
      json['token'],
      UserModel.fromReqBody(jsonEncode(json['user'])),
    );
  }

  Map toJson() => {
        'token': token,
        'user': user
      };


}