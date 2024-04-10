import 'package:flutter/material.dart';
import 'package:frontend_getyourtopic/component/action_base.dart';

class ActionSuccess extends ActionBase {
  const ActionSuccess({
    super.key,
    required super.title,
    required super.content,
  }) : super(
          color: Colors.green,
          titleLeading: const Icon(
            Icons.check_circle_rounded,
            size: 30,
            color: Colors.green,
          ),
        );
}
