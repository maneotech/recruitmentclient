import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String title;
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final bool multilines;
  final Function()? onEnter;
  final Function(String value)? onChanged;

  const TextInput(this.title, this.label, this.isPassword, this.controller,
      {super.key, this.multilines = false, this.onChanged, this.onEnter});

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
          if (widget.multilines)
            getWrappedTextFormField()
          else
            getTextFormField(),
        ],
      ),
    );
  }

  getWrappedTextFormField() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: getTextFormField(),
    );
  }

  getTextFormField() {
    return TextFormField(
      onTap: () => onEnter(),
      onChanged: (value) => onChanged(value),
      maxLines: widget.multilines == true ? null : 1,
      expands: widget.multilines,
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        suffixIcon: getSuffixIcon(),
        labelText: widget.label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: const OutlineInputBorder(),
      ),
    );
  }

  onEnter() {
    if (widget.onEnter != null) {
      widget.onEnter!();
    }
  }

  onChanged(String value){
    if (widget.onChanged != null){
      widget.onChanged!(value);
    }
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
