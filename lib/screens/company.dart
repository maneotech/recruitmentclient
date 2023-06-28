import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recruitmentclient/components/company_row.dart';
import 'package:recruitmentclient/models/company.dart';

import '../components/create_update_company_form.dart';
import '../components/custom_button.dart';
import '../services/api.dart';
import '../services/snack_bar.dart';
import 'base_screen.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final List<Company> _companies = [];

  Company? _companyToUpdate;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var res = await API.getCompanies();
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      List<Company> companies = [];
      for (int i = 0; i < data.length; i++) {
        Company company = Company.fromReqBody(jsonEncode(data[i]));
        companies.add(company);
      }
      _companies.clear();
      setState(() {
        _companies.addAll(companies);
      });
    } else {
      SnackBarService.showError(
          "Une erreur est survenue pendant le chargement des entreprises, merci de réessayer");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(Row(
      children: [
        Expanded(
            child: Column(
                children: [const Text("Entreprises"), getCompanyListWidget()])),
        Expanded(
          child: Column(children: [
            CreateUpdateCompanyForm(
                _companyToUpdate,
                (createdCompany) => addCompany(createdCompany),
                (updatedCompany) => updateCompany(updatedCompany),
                (companyId) => deleteCompany(companyId)),
          ]),
        ),
      ],
    ));
  }

  deleteCompany(String companyId) {
    int i = _companies.indexWhere((element) => element.id == companyId);
    if (i > -1) {
      setState(() {
        _companies.removeAt(i);
        _companyToUpdate = null;
      });
    }


  }

  updateCompany(Company company) {
    int i = _companies.indexWhere((element) => element.id == company.id);
    if (i > -1) {
      setState(() {
        _companies[i] = company;
        _companyToUpdate = company;
      });
    }
  }

  Column getCompanyListWidget() {
    return Column(
      children: [
        CustomButton(
          "Créer une nouvelle entreprise",
          () => updateCurrentCompany(null),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GetUsersList(),
        ),
      ],
    );
  }

  updateCurrentCompany(Company? company) {
    setState(() {
      _companyToUpdate = company;
    });
  }

  Column GetUsersList() {
    return Column(children: [
      Text("Liste des entreprises"),
      ListView.builder(
        shrinkWrap: true,
        itemCount: _companies.length,
        itemBuilder: (context, index) {
          return CompanyRow(
              _companies[index], () => updateCurrentCompany(_companies[index]));
        },
      )
    ]);
  }

  addCompany(Company company) {
    if (_companies.indexWhere(
            (element) => element.id == company.id && company.id != null) ==
        -1) {
      setState(() {
        _companies.add(company);
      });
    }
  }
}
