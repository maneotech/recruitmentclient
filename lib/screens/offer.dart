import 'package:flutter/material.dart';
import 'package:recruitmentclient/screens/base_screen.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(Text("Offer"));
  }
}