import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/models/upload_candidate_response.dart';
import 'package:recruitmentclient/screens/summary_new_candidate.dart';
import 'package:recruitmentclient/services/api.dart';
import 'package:recruitmentclient/services/snack_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../components/create_update_candidate_form.dart';
import '../models/candidate.dart';
import 'base_screen.dart';

class CandidateDetailsScreen extends StatefulWidget {
  final UploadCandidateResponse uploadCandidateResponse;
  final Candidate currentCandidate;
  const CandidateDetailsScreen(this.uploadCandidateResponse, this.currentCandidate,
      {super.key});

  @override
  State<CandidateDetailsScreen> createState() => _CandidateDetailsScreenState();
}

class _CandidateDetailsScreenState extends State<CandidateDetailsScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Candidate? _currentCandidate;
  int _iteration = 1;

  @override
  void initState() {
    super.initState();

    _currentCandidate = widget.currentCandidate;

    if (widget.uploadCandidateResponse.candidates.isNotEmpty) {
      int i = widget.uploadCandidateResponse.candidates
          .indexWhere((element) => element.email == _currentCandidate!.email);
      _iteration = i + 1;
    }
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomButton(
                      "Retourner au sommaire", () => goBackToSummary()),
                  Text("Candidat $_iteration sur ${widget.uploadCandidateResponse.candidates.length}"),
                  getNavigationElement(),
                  CreateUpdateCandidateForm(
                    _currentCandidate,
                    (candidate) => unignoreCandidate(candidate),
                    (candidate) => ignoreCandidate(candidate),
                    (candidate) => updateCandidate(candidate),
                    disableIgnoreCandidate: _currentCandidate!.ignored,
                    disableunignoreCandidate: !_currentCandidate!.ignored,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //************************* Utils ***************************
  replaceInCandidates(Candidate candidate) {

    widget.uploadCandidateResponse.updateCandidateEverywhere(candidate);
    setState(() {
      _currentCandidate = candidate;
    });
  }

  goBackToSummary() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            SummaryNewCandidate(widget.uploadCandidateResponse),
      ),
    );
  }

  //************************* CRUD ***************************
  unignoreCandidate(Candidate candidate) async {
    var res = await API.unignoreCandidate(candidate.id);
    if (res.statusCode == 204) {
      replaceInCandidates(candidate);
    } else {
      SnackBarService.showError("Une erreur est survenue, merci de réessayer");
    }
  }

  ignoreCandidate(Candidate candidate) async {
    var res = await API.ignoreCandidate(candidate.id);
    if (res.statusCode == 204) {
      replaceInCandidates(candidate);
    } else {
      SnackBarService.showError("Une erreur est survenue, merci de réessayer");
    }
  }

  updateCandidate(Candidate candidate) async {
    var res = await API.updateCandidate(candidate);
    if (res.statusCode == 204) {
      replaceInCandidates(candidate);
      SnackBarService.showSuccess("Enregistrement réussi");
    } else {
      SnackBarService.showError("Une erreur est survenue, merci de réessayer");
    }
  }

  //************************* ALGO NAVIGATION ***************************

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

  goToNextCandidateIfPossible() {
    if (_iteration < widget.uploadCandidateResponse.candidates.length) {
      _iteration++;
      setState(() {
        _currentCandidate = widget.uploadCandidateResponse.candidates[_iteration - 1];
      });
    }
  }

  goToPreviousCandidateIfPossible() {
    if (_iteration > 1) {
      _iteration--;
      setState(() {
        _currentCandidate = widget.uploadCandidateResponse.candidates[_iteration - 1];
      });
    }
  }
}
