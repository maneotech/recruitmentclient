import 'dart:convert';

class Candidate {
  String id;
  String firstname;
  String lastname;
  String currentLocation;
  String targetLocation;
  String jobTitle;
  String field;
  int yearsOfExperience;
  List<String> languages;
  String phoneNumber;
  String email;
  List<String> keywords;
  String pictureUrl;
  String cvUrl;
  bool enable;
  bool fulltime;
  bool isFreelance;
  String comment;
  bool ignored;

  Candidate(
    this.id,
    this.firstname,
    this.lastname,
    this.currentLocation,
    this.targetLocation,
    this.jobTitle,
    this.field,
    this.yearsOfExperience,
    this.languages,
    this.phoneNumber,
    this.email,
    this.keywords,
    this.pictureUrl,
    this.cvUrl,
    this.enable,
    this.fulltime,
    this.isFreelance,
    this.comment,
    this.ignored
  );

  factory Candidate.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return Candidate(
      json['id'],
      json['firstname'],
      json['lastname'],
      json['currentLocation'],
      json['targetLocation'],
      json['jobTitle'],
      json['field'],
      json['yearsOfExperience'],
      List<String>.from(json['languages']),
      json['phoneNumber'],
      json['email'],
      List<String>.from(json['keywords']),
      json['pictureUrl'],
      json['cvUrl'],
      json['enable'],
      json['fullTime'],
      json['isFreelance'],
      json['comment'],
      json['ignored']
    );
  }

  // activities.map((activity) => activity.index).toList()
  Map toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'currentLocation': currentLocation,
        'targetLocation' : targetLocation,
        'jobTitle' : jobTitle,
        'field' : field,
        'yearsOfExperience' : yearsOfExperience,
        'phoneNumber': phoneNumber,
        'email': email,
        'keywords': keywords,
        'pictureUrl' : pictureUrl,
        'cvUrl' : cvUrl,
        'enable' : enable,
        'fulltime': fulltime,
        'isFreelance': isFreelance,
        'comment': comment,
        'ignored': ignored
      };
}
