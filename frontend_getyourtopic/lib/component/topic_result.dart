import 'package:flutter/material.dart';
import 'package:frontend_getyourtopic/component/action_success.dart';

class TopicResult extends StatelessWidget {
  final bool isResponseOK;
  final String result;

  const TopicResult({super.key, this.isResponseOK = false, this.result = ""});

  Widget _buildResult() {
    if (isResponseOK) {
      return ActionSuccess(
        title: "話題を考えました！",
        content: result,
      );
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
