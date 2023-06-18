import 'package:flutter/material.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/screens/base_screen.dart';
import 'package:recruitmentclient/screens/import_cvs.dart';
import 'package:recruitmentclient/screens/new_candidate.dart';
import 'package:recruitmentclient/services/api.dart';
import 'package:recruitmentclient/services/toast.dart';

import '../models/candidate.dart';

class SummaryNewCandidate extends StatefulWidget {
  final List<Candidate> allCandidates;
  final List<Candidate> validatedCandidates;
  final List<Candidate> rejectedCandidates;

  const SummaryNewCandidate(
      this.allCandidates, this.validatedCandidates, this.rejectedCandidates,
      {super.key});

  @override
  State<SummaryNewCandidate> createState() => _SummaryNewCandidateState();
}

class _SummaryNewCandidateState extends State<SummaryNewCandidate> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      Column(children: [
        const Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text("Sommaire"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: getValidatedCandidateBlock(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: getRefusedCandidateBlock(),
        ),
        getButtons()
      ]),
    );
  }

  Column getValidatedCandidateBlock() {
    return Column(
      children: [
        const Text("Candidats validés : "),
        ...getValidatedCandidate()
      ],
    );
  }

  Column getRefusedCandidateBlock() {
    return Column(
      children: [const Text("Candidats rejetés : "), ...getRejectedCandidate()],
    );
  }

  List<Text> getValidatedCandidate() {
    List<Text> texts = [];

    for (var candidate in widget.validatedCandidates) {
      texts.add(Text("${candidate.firstname} ${candidate.lastname}"));
    }

    return texts;
  }

  List<Text> getRejectedCandidate() {
    List<Text> texts = [];

    for (var candidate in widget.rejectedCandidates) {
      texts.add(Text("${candidate.firstname} ${candidate.lastname}"));
    }

    return texts;
  }

  Padding getButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        children: [
          CustomButton(
            "Valider ce choix en base de données",
            () => validateAllCandidates(),
          ),
          CustomButton(
            "Revenir en arrière pour effectuer des modifications",
            () => backToUploadsPDF(),
          ),
        ],
      ),
    );
  }

  validateAllCandidates() async {
    var res = await API.acceptCandidates(widget.validatedCandidates);
    if (res.statusCode == 204) {
      ToastService.showSuccess(context, "Les candidats ont bien été insérés en base de données");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              NewCandidateScreen(),
        ),
      );
    } else {
      if (mounted)
        ToastService.showError(
            context, "Une erreur est survenue, merci de réessayer");
    }
  }

  backToUploadsPDF() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            ImportCVsScreen(widget.allCandidates),
      ),
    );
  }
}
