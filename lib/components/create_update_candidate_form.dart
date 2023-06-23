import 'package:flutter/material.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/components/textinput.dart';

import '../models/candidate.dart';

class CreateUpdateCandidateForm extends StatefulWidget {
  final Candidate? candidateToUpdate;
  final Function(Candidate) validateCandidate;
  final Function(Candidate) ignoreCandidate;
  final bool disableValidateCandidate;
  final bool disableIgnoreCandidate;

  const CreateUpdateCandidateForm(
      this.candidateToUpdate, this.validateCandidate, this.ignoreCandidate,
      {this.disableValidateCandidate = false,
      this.disableIgnoreCandidate = false,
      super.key});

  @override
  State<CreateUpdateCandidateForm> createState() =>
      _CreateUpdateCandidateFormState();
}

class _CreateUpdateCandidateFormState extends State<CreateUpdateCandidateForm> {
  final TextEditingController _ctlFirstname = TextEditingController();
  final TextEditingController _ctlLastname = TextEditingController();
  final TextEditingController _ctlCurrentLocation = TextEditingController();
  final TextEditingController _ctlTargetLocation = TextEditingController();
  final TextEditingController _ctlJobTitle = TextEditingController();
  final TextEditingController _ctlField = TextEditingController();
  //final TextEditingController _ctlExperience = TextEditingController();
  //final TextEditingController _ctlLanguages = TextEditingController();
  final TextEditingController _ctlPhoneNumber = TextEditingController();
  final TextEditingController _ctlEmail = TextEditingController();
  final TextEditingController _ctlKeywords = TextEditingController();
  final TextEditingController _ctlComment = TextEditingController();

  //final TextEditingController _ctlFulltime = TextEditingController();
  // final TextEditingController _ctlIsFreelance = TextEditingController();

  @override
  Widget build(BuildContext context) {
    initVariables();

    return Column(
      children: [
        getRow(
          [
            TextInput("Prénom", "Saisir le prénom", false, _ctlFirstname),
            TextInput("Nom", "Saisir le nom", false, _ctlLastname)
          ],
        ),
        getRow([
          TextInput("Current location", "Type current location", false,
              _ctlCurrentLocation),
          TextInput("Target location", "Type target location", false,
              _ctlTargetLocation)
        ]),
        getRow(
          [
            TextInput("Job title", "Type job title", false, _ctlJobTitle),
            TextInput("Field", "Type field", false, _ctlField)
          ],
        ),
        getRow(
          [
            TextInput(
                "Phone number", "Type phone number", false, _ctlPhoneNumber),
            TextInput("Email", "Type email", false, _ctlEmail)
          ],
        ),
        getRow(
          [
            TextInput("Keywords", "Type keywords", false, _ctlKeywords),
            TextInput("Internal comment", "Type internal comment ", false,
                _ctlComment),
          ],
        ),
        CustomButton("Valider ce candidat", () => validateCandidate(), disable: widget.disableValidateCandidate,),
        CustomButton("Ignorer", () => ignoreCandidate(), disable: widget.disableIgnoreCandidate,)
      ],
    );
  }

  Candidate buildCandidate() {
    Candidate candidate = Candidate(
        widget.candidateToUpdate!.id,
        _ctlFirstname.text,
        _ctlLastname.text,
        _ctlCurrentLocation.text,
        _ctlTargetLocation.text,
        _ctlJobTitle.text,
        _ctlField.text,
        0,
        [],
        _ctlPhoneNumber.text,
        _ctlEmail.text,
        _ctlKeywords.text.split(','),
        "",
        "",
        true,
        true,
        false,
        _ctlComment.text);

    return candidate;
  }

  validateCandidate() {
    Candidate candidate = buildCandidate();
    widget.validateCandidate(candidate);
  }

  ignoreCandidate() {
    Candidate candidate = buildCandidate();
    widget.ignoreCandidate(candidate);
  }

  initVariables() {
    if (widget.candidateToUpdate != null) {
      Candidate candidate = widget.candidateToUpdate!;

      _ctlFirstname.text = candidate.firstname;
      _ctlLastname.text = candidate.lastname;
      _ctlCurrentLocation.text = candidate.currentLocation;
      _ctlTargetLocation.text = candidate.targetLocation;
      _ctlJobTitle.text = candidate.jobTitle;
      _ctlField.text = candidate.field;
      _ctlPhoneNumber.text = candidate.phoneNumber;
      _ctlEmail.text = candidate.email;
      _ctlKeywords.text = candidate.keywords.toString();
      _ctlComment.text = candidate.comment;
    }
  }

  Padding getRow(List<Widget> widgets) {
    List<Expanded> expandeds = [];

    for (Widget widget in widgets) {
      expandeds.add(Expanded(
          child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: widget,
      )));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [...expandeds],
      ),
    );
  }
}
