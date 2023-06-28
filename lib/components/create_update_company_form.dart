import 'package:flutter/material.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/components/textinput.dart';
import 'package:recruitmentclient/services/api.dart';
import 'package:recruitmentclient/services/snack_bar.dart';

import '../models/company.dart';

class CreateUpdateCompanyForm extends StatefulWidget {
  final Company? companyToUpdateModel;

  final Function(Company) companyCreated;
  final Function(Company) companyUpdated;
  final Function(String) companyDeleted;

  const CreateUpdateCompanyForm(this.companyToUpdateModel, this.companyCreated,
      this.companyUpdated, this.companyDeleted,
      {super.key});

  @override
  State<CreateUpdateCompanyForm> createState() =>
      _CreateUpdateCompanyFormState();
}

class _CreateUpdateCompanyFormState extends State<CreateUpdateCompanyForm> {
  final TextEditingController _ctlName = TextEditingController();
  final TextEditingController _ctlDescription = TextEditingController();
  final TextEditingController _ctlSize = TextEditingController();
  final TextEditingController _ctlSellingPoints = TextEditingController();
  final TextEditingController _ctlAnnualSales = TextEditingController();
  final TextEditingController _ctlComment = TextEditingController();

  Company? _companyToUpdateModel;
  bool _isUpdateMode = false;

  @override
  Widget build(BuildContext context) {
    initVariables();
    return Column(
      children: [
        getTitle(),
        getRow(
          [
            TextInput(
              "Name",
              "Type company name",
              false,
              _ctlName,
              //onChanged: (value) => resetHasBeenChanged(true),
            ),
            TextInput(
              "Description",
              "Type description",
              false,
              _ctlDescription,
              //onChanged: (value) => resetHasBeenChanged(true),
            )
          ],
        ),
        getRow(
          [
            TextInput(
              "Size",
              "Type company size",
              false,
              _ctlSize,
              //onChanged: (value) => resetHasBeenChanged(true),
            ),
            TextInput(
              "Selling points",
              "Type selling points",
              false,
              _ctlSellingPoints,
              //onChanged: (value) => resetHasBeenChanged(true),
            ),
          ],
        ),
        getRow(
          [
            TextInput(
              "CA annuel",
              "Type CA annuel",
              false,
              _ctlAnnualSales,
              //onChanged: (value) => resetHasBeenChanged(true),
            ),
            TextInput(
              "Comment",
              "Type comment",
              false,
              _ctlComment,
              //onChanged: (value) => resetHasBeenChanged(true),
            )
          ],
        ),
        getCreateUpdateButton(),
      ],
    );
  }

  initVariables() {
    _companyToUpdateModel = widget.companyToUpdateModel;
    if (_companyToUpdateModel != null) {
      _isUpdateMode = true;
      _ctlName.text = _companyToUpdateModel!.name;
      _ctlDescription.text = _companyToUpdateModel!.description;
      _ctlComment.text = _companyToUpdateModel!.comment;
      _ctlAnnualSales.text = _companyToUpdateModel!.annualSales;
      _ctlSellingPoints.text = _companyToUpdateModel!.sellingPoints;
      _ctlSize.text = _companyToUpdateModel!.size;
    } else {
      _isUpdateMode = false;
      _ctlName.text = "";
      _ctlDescription.text = "";
      _ctlComment.text = "";
      _ctlAnnualSales.text = "";
      _ctlSellingPoints.text = "";
      _ctlSize.text = "";
    }
  }

  Text getTitle() {
    if (_isUpdateMode) {
      return const Text("Modification de l'entreprise");
    } else {
      return const Text("Création de l'entreprise");
    }
  }

  Column getCreateUpdateButton() {
    if (_isUpdateMode) {
      return Column(
        children: [
          CustomButton("Modifier cette entreprise", () => updateCompany()),
          CustomButton("Supprimer cette entreprise", () => deleteCompany()),
        ],
      );
    } else {
      return Column(
        children: [
          CustomButton("Créer cette entreprise", () => createCompany()),
        ],
      );
    }
  }

  updateCompany() async {
    if (_ctlName.text.isEmpty) {
      SnackBarService.showError("Le nom de l'entreprise ne peut pas être vide");
      return;
    }

    Company updatedCompany = buildCompany();
    var res = await API.updateCompany(updatedCompany);
    if (res.statusCode == 204) {
      widget.companyUpdated(updatedCompany);
      SnackBarService.showSuccess("L'entreprise a bien été modifiée.");
    } else {
      SnackBarService.showError(
          "L'entreprise n'a pas pu être modifiée. Merci de réessayer");
    }
  }

  deleteCompany() async {
    var res = await API.deleteCompany(_companyToUpdateModel!.id!);
    if (res.statusCode == 200) {
      widget.companyDeleted(_companyToUpdateModel!.id!);
      SnackBarService.showSuccess("L'entreprise a bien été supprimée");
    } else {
      SnackBarService.showError(
          "L'entreprise n'a pas pu être supprimée, merci de réessayer");
    }
  }

  createCompany() async {
    if (_ctlName.text.isEmpty ||
        _ctlDescription.text.isEmpty ||
        _ctlSellingPoints.text.isEmpty ||
        _ctlAnnualSales.text.isEmpty ||
        _ctlSize.text.isEmpty) {
      SnackBarService.showError("Veuillez remplir tous les champs");
      return;
    }

    Company createdCompany = buildCompany();

    var res = await API.createCompany(createdCompany);
    if (res.statusCode == 201) {
      Company c = Company.fromReqBody(res.body);
      widget.companyCreated(c);
    } else if (res.statusCode == 400) {
      SnackBarService.showError("Ce nom d'entreprise existe déjà.");
    } else {
      SnackBarService.showError(
          "Impossible de créer la companie. Merci de réessayer");
    }
  }

  Company buildCompany() {
    String? id = _isUpdateMode ? _companyToUpdateModel!.id! : null;

    return Company(
      _ctlName.text,
      _ctlDescription.text,
      _ctlSize.text,
      _ctlSellingPoints.text,
      _ctlAnnualSales.text,
      _ctlComment.text,
      id: id
    );
  }

  Padding getRow(List<Widget> widgets) {
    List<Expanded> expandeds = [];

    for (Widget widget in widgets) {
      expandeds.add(Expanded(
          child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: widget,
      )));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [...expandeds],
      ),
    );
  }
}
