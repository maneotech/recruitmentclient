import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/screens/summary_new_candidate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../components/create_update_candidate_form.dart';
import '../models/candidate.dart';
import 'base_screen.dart';

class CandidateDetailsScreen extends StatefulWidget {
  final List<Candidate> candidates;
  final Candidate currentCandidate;
  const CandidateDetailsScreen(this.candidates, this.currentCandidate,
      {super.key});

  @override
  State<CandidateDetailsScreen> createState() => _CandidateDetailsScreenState();
}

class _CandidateDetailsScreenState extends State<CandidateDetailsScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  List<Candidate> validateCandidates = [];
  List<Candidate> ignoredCandidates = [];

  Candidate? _currentCandidate;
  int _iteration = 1;
  bool _isCandidateInIgnoredList = false;

  @override
  void initState() {
    super.initState();

    _currentCandidate = widget.currentCandidate;

    if (widget.candidates.isNotEmpty) {
      int i = widget.candidates
          .indexWhere((element) => element.email == _currentCandidate!.email);
      _iteration = i + 1;
    }

    isCandidateInIgnoredList(_currentCandidate);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      SingleChildScrollView(
        child: Row(
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
                  CustomButton(
                      "Retourner au sommaire", () => goBackToSummary()),
                  Text("Candidat $_iteration sur ${widget.candidates.length}"),
                  getNavigationElement(),
                  CreateUpdateCandidateForm(
                    _currentCandidate,
                    (candidate) => validatedCandidate(candidate),
                    (candidate) => ignoreCandidate(candidate),
                    disableIgnoreCandidate: _isCandidateInIgnoredList,
                    disableValidateCandidate: !_isCandidateInIgnoredList,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  isCandidateInIgnoredList(Candidate? candidate) {
    if (candidate == null) {
      _isCandidateInIgnoredList = false;
      return;
    }

    if (ignoredCandidates.indexWhere((element) => element.id == candidate.id) !=
        -1) {
      _isCandidateInIgnoredList = true;
    } else {
      _isCandidateInIgnoredList = false;
    }
  }

  goBackToSummary() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            SummaryNewCandidate(widget.candidates, ignoredCandidates),
      ),
    );
  }

  Row getNavigationElement() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () => goToPreviousCandidateIfPossible(),
            child: const Icon(Icons.arrow_left)),
        TextButton(
          onPressed: () => goToNextCandidateIfPossible(),
          child: const Icon(Icons.arrow_right),
        )
      ],
    );
  }

  validatedCandidate(Candidate candidate) {
    int index = validateCandidates.indexOf(candidate);
    if (index == -1) {
      validateCandidates.add(candidate);
    } else {
      validateCandidates[index] = candidate;
    }

    setState(() {
      _isCandidateInIgnoredList = false;
    });
  }

  ignoreCandidate(Candidate candidate) {
    if (ignoredCandidates.indexWhere((c) => c.id == candidate.id) == -1) {
      ignoredCandidates.add(candidate);
    }

    int indexValidated = validateCandidates.indexWhere((c) => c.id == candidate.id);
    if (indexValidated > -1) {
      validateCandidates.removeAt(indexValidated);
    }

    setState(() {
      _isCandidateInIgnoredList = true;
    });
  }

  goToNextCandidateIfPossible() {
    if (_iteration < widget.candidates.length) {
      _iteration++;
      setState(() {
        _currentCandidate = widget.candidates[_iteration - 1];
      });
    }
  }

  goToPreviousCandidateIfPossible() {
    if (_iteration > 1) {
      _iteration--;
      setState(() {
        _currentCandidate = widget.candidates[_iteration - 1];
      });
    }
  }
}
