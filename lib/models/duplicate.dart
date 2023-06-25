import 'dart:convert';

import 'candidate.dart';

class Duplicate {
  Candidate candidate;
  Candidate duplicate;

  Duplicate(this.candidate, this.duplicate);

  factory Duplicate.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return Duplicate(
      Candidate.fromReqBody(
        jsonEncode(json['candidate']),
      ),
      Candidate.fromReqBody(
        jsonEncode(json['duplicate']),
      ),
    );
  }
}
