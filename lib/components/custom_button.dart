import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final bool disable;
  const CustomButton(this.text, this.onTap, {this.disable = false, super.key});

  @override
  Widget build(BuildContext context) {
    return disable ? getDisabledButtonElement() : getButtonElement();
  }

  getDisabledButtonElement() {
    return TextButton(
      onPressed: null,
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey),
      ),
      onHover: (value) => {},
    );
  }

  getButtonElement() {
    return TextButton(
      onPressed: onTap,
      child: Text(text),
    );
  }
}
