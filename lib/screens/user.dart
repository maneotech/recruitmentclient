import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruitmentclient/components/create_update_user_form.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/components/custom_dropdown.dart';
import 'package:recruitmentclient/components/textinput.dart';
import 'package:recruitmentclient/components/user_row.dart';
import 'package:recruitmentclient/screens/base_screen.dart';
import 'package:recruitmentclient/services/api.dart';
import 'package:recruitmentclient/services/toast.dart';

import '../models/user.dart';
import '../providers/user.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final List<UserModel> _managers = [];
  final List<UserModel> _users = [];

  UserRole? _loggedUserRole;
  UserModel? _userToUpdate;

  @override
  void initState() {
    super.initState();

    _loggedUserRole =
        Provider.of<UserProvider>(context, listen: false).user.role;

    loadData();
  }

  loadData() async {
    if (_loggedUserRole == UserRole.superadmin) {
      loadManagers();
      //load managers
    }

    if (_loggedUserRole == UserRole.superadmin ||
        _loggedUserRole == UserRole.manager) {
      //load users
      loadUsers();
    }
  }

  loadManagers() async {
    var res = await API.getManagers();
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      List<UserModel> managers = [];
      for (int i = 0; i < data.length; i++) {
        UserModel userModel = UserModel.fromReqBody(jsonEncode(data[i]));
        managers.add(userModel);
      }
      _managers.clear();
      setState(() {
        _managers.addAll(managers);
      });
    } else {
      ToastService.showError(
          context, "Une erreur est survenue, merci de réessayer");
    }
  }

  loadUsers() async {}

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: getUserListWidget(),
          )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CreateUpdateUserForm(_userToUpdate),
          )),
        ],
      ),
    );

    // l'écran est partagé en 2 colonnes de même taille.
  }

  Column getUserListWidget() {
    UserModel user = Provider.of<UserProvider>(context, listen: false).user;

    return Column(
      children: [
        if (user.role == UserRole.superadmin) GetManagersList(),
        if (user.role == UserRole.superadmin || user.role == UserRole.manager)
          GetUsersList(),
        CustomButton(
          "Créer un nouvel utilisateur",
          () => updateCurrentUser(null),
        )
      ],
    );
  }

  Column GetManagersList() {
    return Column(children: [
      Text("Liste des managers"),
      ListView.builder(
        shrinkWrap: true,
        itemCount: _managers.length,
        itemBuilder: (context, index) {
          return UserRow(
              _managers[index], () => updateCurrentUser(_managers[index]));
        },
      )
    ]);

    //if role = superadmin on affiche les managers et les users
  }

  updateCurrentUser(UserModel? userModel) {
    setState(() {
      _userToUpdate = userModel;
    });
  }

  Column GetUsersList() {
    return Column(children: [
      Text("Liste des utilisateurs"),
      ListView.builder(
        shrinkWrap: true,
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return UserRow(
              _users[index], () => updateCurrentUser(_users[index]));
        },
      )
    ]);
  }
}
