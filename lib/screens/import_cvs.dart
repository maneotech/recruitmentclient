import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recruitmentclient/screens/summary_new_candidate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../components/create_update_candidate_form.dart';
import '../models/candidate.dart';
import 'base_screen.dart';

class ImportCVsScreen extends StatefulWidget {
  final List<Candidate> candidates;
  const ImportCVsScreen(this.candidates, {super.key});

  @override
  State<ImportCVsScreen> createState() => _ImportCVsScreenState();
}

class _ImportCVsScreenState extends State<ImportCVsScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  List<Candidate> validateCandidates = [];
  List<Candidate> rejectedCandidates = [];

  Candidate? _currentCandidate;
  int _iteration = 1;

  @override
  void initState() {
    super.initState();
    if (widget.candidates.isNotEmpty) {
      _currentCandidate = widget.candidates[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                if (_currentCandidate!.cvUrl.isNotEmpty)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: SfPdfViewer.file(
                      File(_currentCandidate!.cvUrl),
                      //"C:\\Users\\amart\\Documents\\DOCUMENTS\\CV\\alexis_martin_cv.pdf",
                      key: _pdfViewerKey,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text("Candidat $_iteration sur ${widget.candidates.length}"),
                CreateUpdateCandidateForm(
                    _currentCandidate,
                    (candidate) => validatedCandidate(candidate),
                    (candidate) => rejectCandidate(candidate))
              ],
            ),
          )
        ],
      ),
    );
  }

  validatedCandidate(Candidate candidate) {
    if (validateCandidates.contains(candidate) == false) {
      validateCandidates.add(candidate);
    }

    goToNextCandidateIfPossible();
  }

  rejectCandidate(Candidate candidate) {
    if (rejectedCandidates.contains(candidate) == false) {
      rejectedCandidates.add(candidate);
    }

    goToNextCandidateIfPossible();
  }

  goToNextCandidateIfPossible() {
    if (_iteration < widget.candidates.length) {
      _iteration++;
      setState(() {
        _currentCandidate = widget.candidates[_iteration - 1];
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              SummaryNewCandidate(widget.candidates, validateCandidates, rejectedCandidates),
        ),
      );

      //todo ending page
    }
  }
}
