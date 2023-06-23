import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruitmentclient/components/create_update_user_form.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/components/user_row.dart';
import 'package:recruitmentclient/screens/base_screen.dart';
import 'package:recruitmentclient/services/api.dart';

import '../models/user.dart';
import '../providers/user.dart';
import '../services/snack_bar.dart';

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
    }

    if (_loggedUserRole == UserRole.superadmin ||
        _loggedUserRole == UserRole.manager) {
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
      SnackBarService.showError(
          "Une erreur est survenue pendant le chargement des managers, merci de réessayer");
    }
  }

  loadUsers() async {
    var res = await API.getUsers();
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      List<UserModel> users = [];
      for (int i = 0; i < data.length; i++) {
        UserModel userModel = UserModel.fromReqBody(jsonEncode(data[i]));
        users.add(userModel);
      }
      _users.clear();
      setState(() {
        _users.addAll(users);
      });
    } else {
      SnackBarService.showError("Une erreur est survenue pendant le chargement des utilisateurs, merci de réessayer");
    }
  }

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
            child: CreateUpdateUserForm(
              _userToUpdate,
              (userModel) => addCreatedUser(userModel),
              (userModel) => changeUpdatedUser(userModel),
              (username) => deleteUser(username),
            ),
          )),
        ],
      ),
    );

    // l'écran est partagé en 2 colonnes de même taille.
  }

  addCreatedUser(UserModel userModel) {
    if (userModel.role == UserRole.user) {
      if (_users.contains(userModel) == false) {
        setState(() {
          _users.add(userModel);
        });
      }
    } else {
      if (_managers.contains(userModel) == false) {
        setState(() {
          _managers.add(userModel);
        });
      }
    }
  }

  changeUpdatedUser(UserModel userModel) {
    int managerIndex =
        _managers.indexWhere((user) => user.username == userModel.username);
    if (managerIndex != -1) {
      if (userModel.role == UserRole.manager) {
        setState(() {
          _managers[managerIndex] = userModel;
        });
      } else {
        setState(() {
          _managers.removeAt(managerIndex);
          _users.add(userModel);
        });
      }
    } else {
      int userIndex =
          _users.indexWhere((user) => user.username == userModel.username);
      if (userIndex != -1) {
        if (userModel.role == UserRole.user) {
          setState(() {
            _users[userIndex] = userModel;
          });
        } else {
          setState(() {
            _users.removeAt(userIndex);
            _managers.add(userModel);
          });
        }
      }
    }
  }

  deleteUser(String username) {
    var index = _managers.indexWhere((element) => element.username == username);
    if (index != -1) {
      setState(() {
        _managers.removeAt(index);
      });
    } else {
      index = _users.indexWhere((element) => element.username == username);
      if (index != -1) {
        setState(() {
          _users.removeAt(index);
        });
      }
    }
  }

  Column getUserListWidget() {
    UserModel user = Provider.of<UserProvider>(context, listen: false).user;

    return Column(
      children: [
        CustomButton(
          "Créer un nouvel utilisateur",
          () => updateCurrentUser(null),
        ),
        if (user.role == UserRole.superadmin) GetManagersList(),
        if (user.role == UserRole.superadmin || user.role == UserRole.manager)
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: GetUsersList(),
          ),
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
          return UserRow(_users[index], () => updateCurrentUser(_users[index]));
        },
      )
    ]);
  }
}
