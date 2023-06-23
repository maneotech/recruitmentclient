import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/models/home_response.dart';
import 'package:recruitmentclient/services/api.dart';
import 'package:recruitmentclient/services/snack_bar.dart';

import '../components/textinput.dart';
import '../models/user_request.dart';
import '../providers/auth.dart';
import '../providers/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _ctlUsername = TextEditingController();
  final TextEditingController _ctlPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            const Text("Connexion"),
            TextInput(
              "Nom d'utilisateur",
              "Saisir le nom d'utilisateur",
              false,
              _ctlUsername,
            ),
            TextInput(
              "Mot de passe",
              "Saisir le mot de passe",
              true,
              _ctlPassword,
            ),
            CustomButton("Se connecter", () => login())
          ],
        ),
      ),
    );
  }

  login() async {
    if (_ctlUsername.text.isEmpty || _ctlPassword.text.isEmpty) {
      SnackBarService.showError(
          "Veuillez saisir un identifiant et un mot de passe");
      return;
    }

    UserRequestModel userModel =
        UserRequestModel(_ctlUsername.text, _ctlPassword.text);
    var res = await API.login(userModel);

    if (res.statusCode == 200) {
      HomeResponse homeResponse = HomeResponse.fromReqBody(res.body);
      await Provider.of<AuthProvider>(context, listen: false)
          .saveJwtToDisk(homeResponse.token);

      await Provider.of<UserProvider>(context, listen: false)
          .setUser(homeResponse.user);
    } else {
      SnackBarService.showError("Une erreur est survenue, merci de réessayer");
    }
  }
}
