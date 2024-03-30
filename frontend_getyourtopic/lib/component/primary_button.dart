import 'dart:ffi';

import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({super.key, required this.title});

  // This widget is
  final String title;

  @override
  State<PrimaryButton> createState() => _PrimaryButton();
}

class _PrimaryButton extends State<PrimaryButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
    );
  }
}
