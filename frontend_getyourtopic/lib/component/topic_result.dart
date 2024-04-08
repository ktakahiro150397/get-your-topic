import 'package:flutter/material.dart';
import 'package:frontend_getyourtopic/component/action_in_progress.dart';
import 'package:frontend_getyourtopic/component/action_success.dart';

class TopicResult extends StatelessWidget {
  final bool isResponseOK;
  final String result;

  final bool isResponseComplete;

  const TopicResult({
    super.key,
    this.isResponseOK = false,
    this.result = "",
    this.isResponseComplete = false,
  });

  Widget _buildResult() {
    if (isResponseOK) {
      if (isResponseComplete) {
        return ActionSuccess(
          title: "話題を考えてあげました！",
          content: result,
        );
      } else {
        return ActionInProgress(
          title: "考えてあげています...",
          content: result,
        );
      }
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResult(),
      ],
    );
  }
}
