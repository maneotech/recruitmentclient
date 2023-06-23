import 'package:flutter/material.dart';
import 'package:recruitmentclient/screens/base_screen.dart';
import 'package:recruitmentclient/screens/candidate_details.dart';
import '../models/candidate.dart';

class SummaryNewCandidate extends StatefulWidget {
  final List<Candidate> allCandidates;
  final List<Candidate> ignoredCandidates;

  const SummaryNewCandidate(this.allCandidates, this.ignoredCandidates,
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
        if (widget.ignoredCandidates.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: getIgnoredCandidateBlock(),
          ),
      ]),
    );
  }

  Column getValidatedCandidateBlock() {
    return Column(
      children: [
        Text("${widget.allCandidates.length} candidats ajoutés"),
        ...getCandidateRows(widget.allCandidates)
      ],
    );
  }

  Column getIgnoredCandidateBlock() {
    return Column(
      children: [
        const Text("Candidats ignorés : "),
        ...getCandidateRows(widget.ignoredCandidates)
      ],
    );
  }

  List<Row> getCandidateRows(List<Candidate> candidates) {
    List<Row> candidatesRows = [];

    for (var candidate in candidates) {
      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${candidate.firstname} - ${candidate.lastname} - ${candidate.email} - ${candidate.phoneNumber}",
          ),
          IconButton(
            onPressed: () => editCandidate(candidate),
            icon: const Icon(Icons.edit),
          )
        ],
      );
      candidatesRows.add(row);
    }

    return candidatesRows;
  }

  editCandidate(Candidate candidate) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            CandidateDetailsScreen(widget.allCandidates, candidate),
      ),
    );
  }
}
