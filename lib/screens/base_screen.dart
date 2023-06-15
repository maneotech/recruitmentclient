import 'package:flutter/material.dart';

import '../components/vertical_menu.dart';

class BaseScreen extends StatelessWidget {
  final Widget child; 
  const BaseScreen(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          right: 20,
        ),
        child: Row(
          children: [
            const VerticalMenu(),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}