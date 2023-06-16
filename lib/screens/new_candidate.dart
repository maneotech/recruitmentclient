import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/screens/import_cvs.dart';
import 'package:recruitmentclient/services/api.dart';
import 'package:recruitmentclient/services/file.dart';
import 'package:recruitmentclient/services/toast.dart';

import '../models/candidate.dart';
import 'base_screen.dart';

class NewCandidateScreen extends StatefulWidget {
  const NewCandidateScreen({super.key});

  @override
  State<NewCandidateScreen> createState() => _NewCandidateScreenState();
}

class _NewCandidateScreenState extends State<NewCandidateScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomButton("IMPORTER DES CVs", () => importCVs()),
        const Text("OU"),
        CustomButton("CRÉER MANUELLEMENT", () => null)
      ],
    ));
  }

  importCVs() async {
    // get the PDFs
    List<String> pdfFilesPath = await FileService.pickPDFFiles();
    if (pdfFilesPath.isEmpty) {
      return;
    }

    // send these PDF through URL
    var res = await API.uploadCandidates(pdfFilesPath);
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
            List<Candidate> candidates = [];
      for (int i = 0; i < data.length; i++) {
        Candidate candidate = Candidate.fromReqBody(jsonEncode(data[i]));
        candidates.add(candidate);
      }
      //handle response
      goToPage(ImportCVsScreen(candidates));
    } else {
      ToastService.showError(context,
          "Une erreur lors de l'upload des fichiers est survenue. Merci de réessayer");
    }

    //display error
  }

  goToPage(StatefulWidget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => page,
      ),
    );
  }
}
