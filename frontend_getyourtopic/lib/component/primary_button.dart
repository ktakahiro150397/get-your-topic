import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.width,
    this.height,
    this.hintText,
  });

  final String title;
  final double? width;
  final double? height;
  final String? hintText;
  final void Function()? onPressed;

  @override
  State<PrimaryButton> createState() => _PrimaryButton();
}

class _PrimaryButton extends State<PrimaryButton> {
  Widget? buttonChild;

  Widget getButtonChild() {
    return Text(widget.title);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        onPressed: widget.onPressed,
        child: getButtonChild(),
      ),
    );
  }
}
