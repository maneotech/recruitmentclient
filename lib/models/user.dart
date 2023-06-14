import 'dart:convert';

enum UserRole { superadmin, manager, user }

class UserModel {
  String username;
  String firstname;
  String lastname;
  UserRole role;

  UserModel(this.username, this.firstname, this.lastname, this.role);

  factory UserModel.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return UserModel(
        json['username'], json['firstname'], json['lastname'], UserRole.values.firstWhere((e) => e.toString().split('.').last == json['role']));
  }

  Map toJson() => {'username': username, 'firstname': firstname, 'lastname': lastname, 'role': role};
}
