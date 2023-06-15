import 'package:flutter/material.dart';
import 'package:recruitmentclient/models/user.dart';

class CustomDropdown extends StatefulWidget {
  final UserRole selectedValue;
  final Function(UserRole role) onChanged;
  const CustomDropdown(this.selectedValue, this.onChanged, {super.key});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  UserRole? _selectedValue; // Set an initial value

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Rôle"),
        InputDecorator(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserRole>(
                isDense: true,
                focusColor: Colors.white,
                isExpanded: true,
                value: _selectedValue,
                onChanged: (UserRole? newValue) {
                  setState(() {
                    if (newValue != null) {
                      _selectedValue = newValue;
                      widget.onChanged(_selectedValue!);
                    }
                  });
                },
                items: [
                  DropdownMenuItem<UserRole>(
                    value: UserRole.user,
                    child: Text(
                      UserRole.user.toString().split('.').last.toUpperCase(),
                    ),
                  ),
                  DropdownMenuItem<UserRole>(
                    value: UserRole.manager,
                    child: Text(
                      UserRole.manager.toString().split('.').last.toUpperCase(),
                    ),
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}
