import 'package:flutter/material.dart';
import 'package:recruitmentclient/components/custom_button.dart';
import 'package:recruitmentclient/components/textinput.dart';

import '../models/candidate.dart';

class CreateUpdateCandidateForm extends StatefulWidget {
  final Candidate? candidateToUpdate;
  final Function(Candidate) updateCandidate;
  final Function(Candidate) unignoreCandidate;
  final Function(Candidate) ignoreCandidate;
  final bool disableunignoreCandidate;
  final bool disableIgnoreCandidate;

  const CreateUpdateCandidateForm(this.candidateToUpdate,
      this.unignoreCandidate, this.ignoreCandidate, this.updateCandidate,
      {this.disableunignoreCandidate = false,
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

  //bool _hasBeenChanged = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initVariables(widget.candidateToUpdate!);

    return Column(
      children: [
        if (widget.disableIgnoreCandidate == false) getFormElement(),
        if (widget.disableIgnoreCandidate) const Text("Candidat ignoré"),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [getIgnoreButton()],
        )
      ],
    );
  }

  Column getFormElement() {
    return Column(
      children: [
        getRow(
          [
            TextInput(
              "Prénom",
              "Saisir le prénom",
              false,
              _ctlFirstname,
              //onChanged: (value) => resetHasBeenChanged(true),
            ),
            TextInput(
              "Nom",
              "Saisir le nom",
              false,
              _ctlLastname,
              //onChanged: (value) => resetHasBeenChanged(true),
            )
          ],
        ),
        getRow([
          TextInput(
            "Current location",
            "Type current location",
            false,
            _ctlCurrentLocation,
            //onChanged: (value) => resetHasBeenChanged(true),
          ),
          TextInput(
            "Target location",
            "Type target location",
            false,
            _ctlTargetLocation,
            //onChanged: (value) => resetHasBeenChanged(true),
          )
        ]),
        getRow(
          [
            TextInput(
              "Job title",
              "Type job title",
              false,
              _ctlJobTitle,
              //onChanged: (value) => resetHasBeenChanged(true),
            ),
            TextInput(
              "Field",
              "Type field",
              false,
              _ctlField,
              //onChanged: (value) => resetHasBeenChanged(true),
            )
          ],
        ),
        getRow(
          [
            TextInput(
              "Phone number",
              "Type phone number",
              false,
              _ctlPhoneNumber,
              //onChanged: (value) => resetHasBeenChanged(true),
            ),
            TextInput(
              "Email",
              "Type email",
              false,
              _ctlEmail,
              //onChanged: (value) => resetHasBeenChanged(true),
            )
          ],
        ),
        getRow(
          [
            TextInput(
              "Keywords",
              "Type keywords",
              false,
              _ctlKeywords,
              //onChanged: (value) => resetHasBeenChanged(true),
            ),
            TextInput(
              "Internal comment",
              "Type internal comment ",
              false,
              _ctlComment,
              //onChanged: (value) => resetHasBeenChanged(true),
            ),
          ],
        ),
        CustomButton("Mettre à jour les modifications", () => updateCandidate(),
            /*disable: !_hasBeenChanged*/),
      ],
    );
  }

  /*resetHasBeenChanged(bool hasChanged) {
    if (_hasBeenChanged != hasChanged) {
      setState(() {
        _hasBeenChanged = hasChanged;
      });
    }
  }*/

  CustomButton getIgnoreButton() {
    if (widget.disableIgnoreCandidate) {
      return CustomButton("Ne plus ignorer", () => unignoreCandidate(),
          disable: widget.disableunignoreCandidate);
    } else {
      return CustomButton(
        "Ignorer",
        () => ignoreCandidate(),
        disable: widget.disableIgnoreCandidate,
      );
    }
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
        widget.candidateToUpdate!.cvUrl,
        true,
        true,
        false,
        _ctlComment.text,
        false);

    return candidate;
  }

  updateCandidate() {
    Candidate candidate = buildCandidate();
    widget.updateCandidate(candidate);
    //resetHasBeenChanged(false);
  }

  unignoreCandidate() {
    Candidate candidate = buildCandidate();
    candidate.ignored = false;
    widget.unignoreCandidate(candidate);

     //resetHasBeenChanged(false);
  }

  ignoreCandidate() {
    Candidate candidate = buildCandidate();
    candidate.ignored = true;
    widget.ignoreCandidate(candidate);

     //resetHasBeenChanged(false);
  }

  initVariables(Candidate candidate) {
      _ctlFirstname.text = candidate.firstname;
      _ctlLastname.text = candidate.lastname;
      _ctlCurrentLocation.text = candidate.currentLocation;
      _ctlTargetLocation.text = candidate.targetLocation;
      _ctlJobTitle.text = candidate.jobTitle;
      _ctlField.text = candidate.field;
      _ctlPhoneNumber.text = candidate.phoneNumber;
      _ctlEmail.text = candidate.email;
      _ctlKeywords.text = candidate.keywords.toString().replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "");
      _ctlComment.text = candidate.comment;
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
