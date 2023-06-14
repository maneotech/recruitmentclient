import 'dart:convert';

class UserRequestModel {
  String username;
  String password;

  UserRequestModel(this.username, this.password);

  factory UserRequestModel.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return UserRequestModel(
      json['username'],
      json['password'],
    );
  }

  Map toJson() => {
        'username': username,
        'password': password
      };


}