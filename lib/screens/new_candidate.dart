import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/screens/summary_new_candidate.dart';
import 'package:recruitmentclient/services/api.dart';
import 'package:recruitmentclient/services/file.dart';

import '../components/drag_and_drop_space.dart';
import '../models/candidate.dart';
import '../services/snack_bar.dart';
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Importer des CVs"),
            PDFDragAndDropSpace(
              onTap: () => importCVs(),
              onResult: (filepaths) => uploadCandidates(filepaths) ,
            ),
            const Text("Accepte uniquement des fichiers PDFs")
          ],
        ),
        const Text("OU"),
        CustomButton("CRÉER MANUELLEMENT", () => null)
      ],
    ));
  }

  importCVs() async {
    List<String> pdfFilesPath = await FileService.pickPDFFiles();
    uploadCandidates(pdfFilesPath);
  }

  uploadCandidates(List<String> pdfFilesPath) async {
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
      goToPage(SummaryNewCandidate(candidates, []));
    } else {
      SnackBarService.showError(
          "Une erreur lors de l'upload des fichiers est survenue. Merci de réessayer");
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
}
