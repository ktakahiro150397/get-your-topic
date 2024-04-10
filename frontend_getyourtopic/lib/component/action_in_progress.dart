import 'package:flutter/material.dart';
import 'package:frontend_getyourtopic/component/action_base.dart';

class ActionInProgress extends ActionBase {
  const ActionInProgress({
    super.key,
    required super.title,
    required super.content,
  }) : super(
          color: Colors.blue,
          titleLeading: const Icon(
            Icons.psychology,
            size: 30,
            color: Colors.blue,
          ),
        );
}
