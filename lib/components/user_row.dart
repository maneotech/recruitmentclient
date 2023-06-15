import 'package:flutter/material.dart';

import '../models/user.dart';

class UserRow extends StatelessWidget {
  final UserModel userModel;
  final Function() callback;
  const UserRow(this.userModel, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(userModel.username),
        Text(userModel.firstname),
        Text(userModel.lastname),
        Text(userModel.role.toString().split('.').last),
        IconButton(onPressed: () => callback(), icon: const Icon(Icons.arrow_right))
      ],
    );
  }  
}
