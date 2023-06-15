import 'dart:convert';

enum UserRole { superadmin, manager, user }

class UserModel {
  String username;
  String firstname;
  String lastname;
  String? password;
  UserRole role;

  UserModel(
      this.username, this.firstname, this.lastname, this.password, this.role);

  factory UserModel.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return UserModel(
        json['username'],
        json['firstname'],
        json['lastname'],
        null,
        UserRole.values
            .firstWhere((e) => e.index == json['role']));
  }

  Map toJson() => {
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
        'password': password,
        'role': role.index
      };
}
