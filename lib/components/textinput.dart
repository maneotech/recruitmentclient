import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String title;
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  const TextInput(this.title, this.label, this.isPassword, this.controller,
      {super.key});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              suffixIcon: getSuffixIcon(),
              labelText: widget.label,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: const OutlineInputBorder(),
            ),
          )
        ],
      ),
    );
  }

  IconButton getSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: const Icon(
          Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () => onClickVisibility(),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => onDelete(),
      );
    }
  }

  onClickVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  onDelete() {
    widget.controller.text = "";
  }
}
