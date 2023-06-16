import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruitmentclient/components/textinput.dart';

import '../models/user.dart';
import '../providers/user.dart';
import '../services/api.dart';
import '../services/toast.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';

class CreateUpdateUserForm extends StatefulWidget {
  final UserModel? _userToUpdateModel;
  final Function(UserModel) userCreated;
  final Function(UserModel) userUpdated;
  final Function(String) userDeleted;
  const CreateUpdateUserForm(
      this._userToUpdateModel, this.userCreated, this.userUpdated, this.userDeleted,
      {super.key});

  @override
  State<CreateUpdateUserForm> createState() => _CreateUpdateUserFormState();
}

class _CreateUpdateUserFormState extends State<CreateUpdateUserForm> {
  UserModel? _userToUpdateModel;

  final TextEditingController _ctlUsername = TextEditingController();
  final TextEditingController _ctlFirstname = TextEditingController();
  final TextEditingController _ctlLastname = TextEditingController();
  final TextEditingController _ctlPassword = TextEditingController();
  final TextEditingController _ctlConfirmPassword = TextEditingController();
  UserRole _newUserRole = UserRole.user;

  //logged user role
  UserRole? _loggedUserRole;
  bool _isUpdateMode = false;

  @override
  void initState() {
    super.initState();
    _loggedUserRole =
        Provider.of<UserProvider>(context, listen: false).user.role;
  }

  @override
  Widget build(BuildContext context) {
    initVariables();

    return Column(
      children: [
        getTitle(),
        TextInput("Identifiant", "Saisir l'identifiant", false, _ctlUsername),
        TextInput("Prénom", "Saisir le prénom", false, _ctlFirstname),
        TextInput("Nom", "Saisir le nom", false, _ctlLastname),
        if (_loggedUserRole == UserRole.superadmin)
          CustomDropdown(_newUserRole, (role) => setRole(role)),
        TextInput("Mot de passe", "Saisir le mot de passe", true, _ctlPassword),
        TextInput(
            "Confirmation du mot de passe",
            "Saisir la confirmation du mot de passe",
            true,
            _ctlConfirmPassword),
        if (_isUpdateMode)
          const Text(
              "Si vous laissez les mots de passe vide, la modification du mot de passe ne sera pas prise en compte"),
        getCreateUpdateButton(),
      ],
    );
  }

  Text getTitle() {
    if (_isUpdateMode) {
      return const Text("Modification de l'utilisateur");
    } else {
      return const Text("Créer un nouvel utilisateur");
    }
  }

  Column getCreateUpdateButton() {
    if (_isUpdateMode) {
      return Column(
        children: [
          CustomButton("Modifier cet utilisateur", () => updateUser()),
          CustomButton("Supprimer cet utilisateur", () => removeUser()),
        ],
      );
    } else {
      return Column(
        children: [
          CustomButton("Créer cet utilisateur", () => createUser()),
        ],
      );
    }
  }

  initVariables() {
    _userToUpdateModel = widget._userToUpdateModel;

    //is userModel exists, it is not creation mode but update mode
    if (_userToUpdateModel != null) {
      _isUpdateMode = true;
      _ctlUsername.text = _userToUpdateModel!.username;
      _ctlFirstname.text = _userToUpdateModel!.firstname;
      _ctlLastname.text = _userToUpdateModel!.lastname;
      _newUserRole = _userToUpdateModel!.role;
    } else {
      _isUpdateMode = false;
      _ctlUsername.text = "";
      _ctlFirstname.text = "";
      _ctlLastname.text = "";
      _ctlPassword.text = "";
      _ctlConfirmPassword.text = "";
      _newUserRole = UserRole.user;
    }
  }

  setRole(UserRole role) {
    _newUserRole = role;
  }

  createUser() async {
    if (_ctlUsername.text.isEmpty ||
        _ctlFirstname.text.isEmpty ||
        _ctlLastname.text.isEmpty ||
        _ctlPassword.text.isEmpty ||
        _ctlConfirmPassword.text.isEmpty) {
      ToastService.showError(context, "Veuillez remplir tous les champs");
      return;
    }

    if (_ctlPassword.text != _ctlConfirmPassword.text) {
      ToastService.showError(
          context, "Les mots de passe doivent être identiques");
      return;
    }

    UserModel userModel = UserModel(_ctlUsername.text, _ctlFirstname.text,
        _ctlLastname.text, _ctlPassword.text, _newUserRole);
    var res = await API.createUser(userModel);

    if (res.statusCode == 201) {
      widget.userCreated(userModel);
      ToastService.showSuccess(context, "L'utilisateur a bien été créé");
    } else if (res.statusCode == 409) {
      ToastService.showError(
          context, "Un utilisateur possède déjà cet identifiant");
    } else {
      ToastService.showError(
          context, "Une erreur est survenue, merci de réessayer");
    }
  }

  updateUser() async {
    if (_ctlUsername.text.isEmpty ||
        _ctlFirstname.text.isEmpty ||
        _ctlLastname.text.isEmpty) {
      ToastService.showError(
          context, "Veuillez remplir l'identifiant, le prénom et le nom");
      return;
    }

    if (_ctlPassword.text != _ctlConfirmPassword.text) {
      ToastService.showError(
          context, "Les mots de passe doivent être identiques");
      return;
    }

    UserModel userModel = UserModel(_ctlUsername.text, _ctlFirstname.text,
        _ctlLastname.text, _ctlPassword.text, _newUserRole);
    var res = await API.updateUser(userModel);
    if (res.statusCode == 204) {
      widget.userUpdated(userModel);
      ToastService.showSuccess(context, "L'utilisateur a bien été modifié");
    } else if (res.statusCode == 409) {
      ToastService.showError(
          context, "Un utilisateur possède déjà cet identifiant");
    } else {
      ToastService.showError(
          context, "Une erreur est survenue, merci de réessayer");
    }
  }

  removeUser() async {
    if (_ctlUsername.text.isEmpty) {
      ToastService.showError(context,
          "Un identifiant est nécessaire pour supprimer un utilisateur");
      return;
    }

    var res = await API.deleteUser(_ctlUsername.text);
    if (res.statusCode == 200) {
      widget.userDeleted(_ctlUsername.text);
      ToastService.showSuccess(context, "L'utilisateur a bien été supprimé");
    } else {
      ToastService.showError(
          context, "Une erreur est survenue, merci de réessayer");
    }
  }
}
