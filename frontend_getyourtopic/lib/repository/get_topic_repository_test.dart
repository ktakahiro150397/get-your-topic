import 'package:frontend_getyourtopic/repository/get_topic_repository.dart';

class GetTopicRepositoryTest extends GetTopicRepository {
  @override
  Future<String> getTopic(String prompt) async {
    await Future.delayed(const Duration(seconds: 3));
    return "getTopic / Your prompt is $prompt!";
  }
}
