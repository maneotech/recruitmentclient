import 'dart:convert';

import 'package:recruitmentclient/models/duplicate.dart';

import 'candidate.dart';

class UploadCandidateResponse {
  List<Candidate> candidates;
  List<Duplicate> duplicates;

  UploadCandidateResponse(this.candidates, this.duplicates);

  factory UploadCandidateResponse.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    var candidateList = json['candidates'] as List<dynamic>;
    List<Candidate> candidates = candidateList.map((candidateJson) {
      return Candidate.fromReqBody(jsonEncode(candidateJson));
    }).toList();

    var duplicateList = json['duplicates'] as List<dynamic>;
    List<Duplicate> duplicates = duplicateList.map((duplicateJson) {
      return Duplicate.fromReqBody(jsonEncode(duplicateJson));
    }).toList();

    return UploadCandidateResponse(
      candidates,
      duplicates,
    );
  }

  updateCandidateEverywhere(Candidate candidate) {
    var index = candidates.indexWhere((element) => element.id == candidate.id);
    if (index > -1) {
      candidates[index] = candidate;
    }

    index = duplicates.indexWhere((element) => element.candidate.id == candidate.id);
    if (index > -1) {
      duplicates[index].candidate = candidate;
    }

    index = duplicates.indexWhere((element) => element.duplicate.id == candidate.id);
    if (index > -1) {
      duplicates[index].duplicate = candidate;
    }
  }
}
