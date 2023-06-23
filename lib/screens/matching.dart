import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/components/textinput.dart';
import 'package:recruitmentclient/models/matching.dart';
import 'package:recruitmentclient/screens/base_screen.dart';
import 'package:recruitmentclient/services/api.dart';

import '../services/snack_bar.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  final TextEditingController _ctlOffer = TextEditingController();
  List<Matching> _matchedCandidates = [];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      SingleChildScrollView(
        child: Column(
          children: [
            const Text(
                "Copier/coller l'offre d'emploi dans l'encadré ci-dessous"),
            TextInput(
              "Offre d'emploi",
              "Saisir l'offre d'emploi",
              false,
              _ctlOffer,
              multilines: true,
            ),
            CustomButton(
                "Chercher les meilleurs matchs", () => findBestMatches()),
            getMatchedCandidatesBlock(),
          ],
        ),
      ),
    );
  }

  findBestMatches() async {
    if (_ctlOffer.text.isEmpty) {
      SnackBarService.showError("Veuillez saisir l'offre d'emploi");
      return;
    }

    var res = await API.findBestMatches(_ctlOffer.text);
    if (res.statusCode == 200) {
      List<dynamic> data = jsonDecode(res.body);
      List<Matching> matchs = [];
      for (int i = 0; i < data.length; i++) {
        Matching match = Matching.fromReqBody(jsonEncode(data[i]));
        matchs.add(match);
      }

      _matchedCandidates = [];
      setState(() {
        _matchedCandidates.addAll(matchs);
      });
    } else {
      SnackBarService.showError("Une erreur est survenue. Merci de réessayer.");
    }
  }

  Column getMatchedCandidatesBlock() {
    List<Text> candidates = [];
    for (Matching matching in _matchedCandidates) {
      candidates.add(
        Text(
            "${matching.candidate.firstname} ${matching.candidate.lastname} - matching à : ${matching.score} %"),
      );
    }
    return Column(
      children: [...candidates],
    );
  }
}
