import 'package:frontend_getyourtopic/model/get_topic.dart';
import 'package:frontend_getyourtopic/repository/get_topic_repository.dart';

class GetTopicRepositoryTest extends GetTopicRepository {
  @override
  Future<GetTopic> getTopic(String prompt, {String? pictureBase64}) async {
    await Future.delayed(const Duration(seconds: 3));

    return GetTopic(
        model: "GetTopicRepositoryTest",
        response: "getTopic / Your prompt is $prompt! base64:$pictureBase64");
  }
}
