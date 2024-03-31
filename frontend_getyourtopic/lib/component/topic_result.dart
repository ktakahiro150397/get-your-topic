import 'package:flutter/material.dart';

class TopicResult extends StatelessWidget {
  final bool isLoading;
  final String result;

  const TopicResult({super.key, this.isLoading = false, this.result = ""});

  Widget _buildResult() {
    if (isLoading) {
      return const CircularProgressIndicator();
    } else {
      return Text(result);
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
