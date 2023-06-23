import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruitmentclient/components/textinput.dart';
import 'package:recruitmentclient/services/snack_bar.dart';

import '../models/user.dart';
import '../providers/user.dart';
import '../services/api.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';

class CreateUpdateUserForm extends StatefulWidget {
  final UserModel? _userToUpdateModel;
  final Function(UserModel) userCreated;
  final Function(UserModel) userUpdated;
  final Function(String) userDeleted;
  const CreateUpdateUserForm(this._userToUpdateModel, this.userCreated,
      this.userUpdated, this.userDeleted,
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
  bool _changesInProgress = false;

  @override
  void initState() {
    super.initState();
    _loggedUserRole =
        Provider.of<UserProvider>(context, listen: false).user.role;
  }

  @override
  void dispose() {
    hideModificationInProgress();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initVariables();
    hideModificationInProgress();

    return Column(
      children: [
        getTitle(),
        TextInput(
          "Prénom",
          "Saisir le prénom",
          false,
          _ctlFirstname,
          onChanged: (value) => showModificationInProgress(),
        ),
        TextInput("Nom", "Saisir le nom", false, _ctlLastname,
            onChanged: (value) => showModificationInProgress()),
        TextInput("Nom d'utilisateur", "Saisir le nom d'utilisateur", false,
            _ctlUsername,
            onEnter: () => preFillUsername(),
            onChanged: (value) => showModificationInProgress()),
        if (_loggedUserRole == UserRole.superadmin)
          CustomDropdown(_newUserRole, (role) => setRole(role)),
        TextInput(
          "Mot de passe",
          "Saisir le mot de passe",
          true,
          _ctlPassword,
          onChanged: (value) => showModificationInProgress(),
        ),
        TextInput(
          "Confirmation du mot de passe",
          "Saisir la confirmation du mot de passe",
          true,
          _ctlConfirmPassword,
          onChanged: (value) => showModificationInProgress(),
        ),
        if (_isUpdateMode)
          const Text(
              "Si vous laissez les mots de passe vide, la modification du mot de passe ne sera pas prise en compte"),
        getCreateUpdateButton(),
      ],
    );
  }

  showModificationInProgress() {
    if (_changesInProgress == false) {
      _changesInProgress = true;
      SnackBarService.showInformation("Une modification est en cours",
          isInfiniteDuration: true);
    }
  }

  hideModificationInProgress() {
    if (_changesInProgress == true) {
      _changesInProgress = false;
      SnackBarService.hideCurrentToast();
    }
  }

  Text getTitle() {
    if (_isUpdateMode) {
      return const Text("Modification de l'utilisateur");
    } else {
      return const Text("Créer un nouvel utilisateur");
    }
  }

  preFillUsername() {
    if (_isUpdateMode == false &&
        _ctlFirstname.text.isNotEmpty &&
        _ctlLastname.text.isNotEmpty &&
        _ctlUsername.text.isEmpty) {
      _ctlUsername.text =
          "${_ctlFirstname.text}.${_ctlLastname.text}".toLowerCase();

      _ctlUsername.selection = TextSelection.fromPosition(
          TextPosition(offset: _ctlUsername.text.length));
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
      _ctlPassword.text = "";
      _ctlConfirmPassword.text = "";
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
      SnackBarService.showError("Veuillez remplir tous les champs");
      return;
    }

    if (_ctlPassword.text != _ctlConfirmPassword.text) {
      SnackBarService.showError("Les mots de passe doivent être identiques");
      return;
    }

    UserModel userModel = UserModel(_ctlUsername.text, _ctlFirstname.text,
        _ctlLastname.text, _ctlPassword.text, _newUserRole);
    var res = await API.createUser(userModel);

    if (res.statusCode == 201) {
      widget.userCreated(userModel);
      hideModificationInProgress();
      SnackBarService.showSuccess("L'utilisateur a bien été créé");
      _changesInProgress = false;
    } else if (res.statusCode == 409) {
      SnackBarService.showError("Un utilisateur possède déjà cet identifiant");
    } else {
      SnackBarService.showError("Une erreur est survenue, merci de réessayer");
    }
  }

  updateUser() async {
    if (_ctlUsername.text.isEmpty ||
        _ctlFirstname.text.isEmpty ||
        _ctlLastname.text.isEmpty) {
      SnackBarService.showError(
          "Veuillez remplir l'identifiant, le prénom et le nom");
      return;
    }

    if (_ctlPassword.text != _ctlConfirmPassword.text) {
      SnackBarService.showError("Les mots de passe doivent être identiques");
      return;
    }

    UserModel userModel = UserModel(_ctlUsername.text, _ctlFirstname.text,
        _ctlLastname.text, _ctlPassword.text, _newUserRole);
    var res = await API.updateUser(userModel);
    if (res.statusCode == 204) {
      widget.userUpdated(userModel);
      hideModificationInProgress();
      SnackBarService.showSuccess("L'utilisateur a bien été modifié");
    } else if (res.statusCode == 409) {
      SnackBarService.showError("Un utilisateur possède déjà cet identifiant");
    } else {
      SnackBarService.showError("Une erreur est survenue, merci de réessayer");
    }
  }

  removeUser() async {
    if (_ctlUsername.text.isEmpty) {
      SnackBarService.showError(
          "Un identifiant est nécessaire pour supprimer un utilisateur");
      return;
    }

    var res = await API.deleteUser(_ctlUsername.text);
    if (res.statusCode == 200) {
      widget.userDeleted(_ctlUsername.text);
      hideModificationInProgress();
      SnackBarService.showSuccess("L'utilisateur a bien été supprimé");
    } else {
      SnackBarService.showError("Une erreur est survenue, merci de réessayer");
    }
  }
}
