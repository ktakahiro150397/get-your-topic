import 'package:flutter/material.dart';

abstract class ActionBase extends StatelessWidget {
  const ActionBase(
      {super.key,
      required this.title,
      required this.content,
      required this.color,
      required this.titleLeading});

  final String title;
  final String content;
  final MaterialColor color;
  final Widget titleLeading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              titleLeading,
              SelectableText(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(content),
        ]),
      ),
    );
  }
}
