import 'dart:convert';

import 'candidate.dart';

class Matching {
  int score;
  Candidate candidate;

  Matching(this.score, this.candidate);

  factory Matching.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return Matching(
      json['score'],
      Candidate.fromReqBody(
        jsonEncode(json['candidate']),
      ),
    );
  }
}
