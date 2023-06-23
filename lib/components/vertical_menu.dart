import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruitmentclient/models/user.dart';
import 'package:recruitmentclient/screens/matching.dart';
import 'package:recruitmentclient/screens/new_candidate.dart';

import '../providers/auth.dart';
import '../providers/user.dart';
import '../screens/user.dart';

class VerticalMenu extends StatefulWidget {
  const VerticalMenu({super.key});

  @override
  State<VerticalMenu> createState() => _VerticalMenuState();
}

class _VerticalMenuState extends State<VerticalMenu> {
  UserModel? _loggedUser;
  @override
  void initState() {
    super.initState();
    _loggedUser = Provider.of<UserProvider>(context, listen: false).user;
  }

  @override
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
                  leading: Icon(Icons.handshake),
                  title: Text('Matching'),
                  onTap: () => goToPage(const MatchingScreen())),
              ListTile(
                  leading: Icon(Icons.edit_document),
                  title: Text('Nouveaux candidats'),
                  onTap: () => goToPage(const NewCandidateScreen())),
              if (_loggedUser!.role != UserRole.user)
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
    if (_loggedUser != null) {
      return Column(children: [
        Text("${_loggedUser!.firstname} ${_loggedUser!.lastname} "),
        Text("username: ${_loggedUser!.username}"),
        Text("role: ${_loggedUser!.role.toString().split('.').last}"),
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
    Navigator.pushReplacementNamed(context, '/');
  }
}
