import 'package:flutter/material.dart';

class PrimaryButtonLoadable extends StatefulWidget {
  const PrimaryButtonLoadable({
    super.key,
    required this.title,
    this.onPressed,
    this.width,
    this.height,
    this.hintText,
    this.isLoading = false,
    this.loadingWidget,
  });

  final String title;
  final double? width;
  final double? height;
  final String? hintText;
  final void Function()? onPressed;

  final bool isLoading;
  final Widget? loadingWidget;

  @override
  State<PrimaryButtonLoadable> createState() => _PrimaryButtonLoadable();
}

class _PrimaryButtonLoadable extends State<PrimaryButtonLoadable> {
  Widget? buttonChild;

  Widget getButtonChild() {
    if (!widget.isLoading) {
      return Text(widget.title);
    } else {
      return widget.loadingWidget ?? const CircularProgressIndicator();
    }
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
