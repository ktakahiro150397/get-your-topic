import 'package:flutter/material.dart';

class ActionSuccess extends StatelessWidget {
  const ActionSuccess({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 30,
                color: Colors.green,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content),
        ]),
      ),
    );
  }
}
