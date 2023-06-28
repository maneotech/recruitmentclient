import 'package:flutter/material.dart';

import '../models/company.dart';

class CompanyRow extends StatelessWidget {
  final Company companyModel;
  final Function() callback;

  const CompanyRow(this.companyModel, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(companyModel.name),
        Text(companyModel.description),
        Text(companyModel.size),
        Text(companyModel.sellingPoints),
        IconButton(
            onPressed: () => callback(), icon: const Icon(Icons.arrow_right))
      ],
    );
  }
}
