import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruitmentclient/models/user.dart';

import '../providers/auth.dart';
import '../providers/user.dart';
import '../screens/user.dart';

class VerticalMenu extends StatefulWidget {
  const VerticalMenu({super.key});

  @override
  State<VerticalMenu> createState() => _VerticalMenuState();
}

class _VerticalMenuState extends State<VerticalMenu> {
  UserModel? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UserModel? user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      logout();
    } else {
      _user = user;
    }
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.2,
      child: Column(

        children: <Widget>[
          getHeaderUserInfo(),
          ListView(
            shrinkWrap: true, // use it
            children: [
              ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Users'),
                  onTap: () => goToPage(const UserScreen())),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () => logout(),
              )
            ],
          )
        ],
      ),
    );
  }

  getHeaderUserInfo() {
    if (_user != null) {
      return Column(children: [
        Text("${_user!.firstname} ${_user!.lastname} "),
        Text("username: ${_user!.username}"),
        Text("role: ${_user!.role.toString().split('.').last}"),
      ]);
    } else {
      return Text("");
    }
  }

  goToPage(StatefulWidget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => page,
      ),
    );
  }

  logout() async {
    await Provider.of<AuthProvider>(context, listen: false).logout();
  }
}
