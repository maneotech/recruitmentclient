import 'package:flutter/material.dart';
import 'package:recruitmentclient/models/duplicate.dart';
import 'package:recruitmentclient/screens/base_screen.dart';
import 'package:recruitmentclient/screens/candidate_details.dart';
import '../models/candidate.dart';
import '../models/upload_candidate_response.dart';

class SummaryNewCandidate extends StatefulWidget {
  final UploadCandidateResponse uploadCandidateResponse;

  const SummaryNewCandidate(this.uploadCandidateResponse, {super.key});

  @override
  State<SummaryNewCandidate> createState() => _SummaryNewCandidateState();
}

class _SummaryNewCandidateState extends State<SummaryNewCandidate> {
  List<Candidate> _allCandidates = [];
  final List<Candidate> _validatedCandidates = [];
  final List<Candidate> _ignoredCandidates = [];
  List<Duplicate> _duplicatedCandidates = [];

  @override
  void initState() {
    super.initState();

    _allCandidates = List.from(widget.uploadCandidateResponse.candidates);

    _validatedCandidates
        .addAll(_allCandidates.where((element) => element.ignored == false));
    _ignoredCandidates
        .addAll(_allCandidates.where((element) => element.ignored == true));

    _duplicatedCandidates =
        List.from(widget.uploadCandidateResponse.duplicates.where((element) => element.candidate.ignored == false && element.duplicate.ignored == false));
  }

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
          child: getIgnoredCandidateBlock(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: getDuplicatesBlock(),
        ),
      ]),
    );
  }

  Column getValidatedCandidateBlock() {
    return Column(
      children: [
        Text("${_validatedCandidates.length} candidats ajoutés"),
        ...getCandidateRows(_validatedCandidates)
      ],
    );
  }

  Column getIgnoredCandidateBlock() {
    return Column(
      children: [
        Text("${_ignoredCandidates.length} candidats ignorés"),
        ...getCandidateRows(_ignoredCandidates)
      ],
    );
  }

  Column getDuplicatesBlock() {
    return Column(
      children: [
        Text("${_duplicatedCandidates.length} candidats en double"),
        ...getDuplicatesRows()
      ],
    );
  }

  List<Row> getDuplicatesRows() {
    List<Row> duplicatesRows = [];

    Row row = const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(
        children: [Text("Candidat qui vient d'être importé")],
      ),
      Column(
        children: [Text("Candidat déjà présent en base de données")],
      )
    ]);

    duplicatesRows.add(row);

    for (var duplicate in _duplicatedCandidates) {
      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [getCandidateRow(duplicate.candidate)],
          ),
          Column(
            children: [getCandidateRow(duplicate.duplicate)],
          )
        ],
      );

      duplicatesRows.add(row);
    }

    return duplicatesRows;
  }

  List<Row> getCandidateRows(List<Candidate> candidates) {
    List<Row> candidatesRows = [];

    for (var candidate in candidates) {
      candidatesRows.add(getCandidateRow(candidate));
    }

    return candidatesRows;
  }

  Row getCandidateRow(Candidate candidate) {
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

    return row;
  }

  editCandidate(Candidate candidate) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            CandidateDetailsScreen(widget.uploadCandidateResponse, candidate),
      ),
    );
  }
}
