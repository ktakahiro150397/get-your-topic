import 'package:frontend_getyourtopic/model/get_topic.dart';
import 'package:frontend_getyourtopic/repository/get_topic_repository.dart';

class GetTopicRepositoryTest extends GetTopicRepository {
  @override
  Future<GetTopic> getTopic(String prompt, {String? pictureBase64}) async {
    await Future.delayed(const Duration(seconds: 3));

    return GetTopic(
        model: "GetTopicRepositoryTest",
        response:
            "getTopic / Your prompt is $prompt! base64:${pictureBase64?.isEmpty}");
  }

  @override
  Future<Stream<String>> getTopicStream(String prompt,
      {String? pictureBase64}) async {
    // String responseString =
    //     "Streaming from getTopicStream! Can you read this? prompt:$prompt / pictureBase64:$pictureBase64";

    // for (var i = 0; i < responseString.length; i++) {
    //   await Future.delayed(const Duration(milliseconds: 10));
    //   yield responseString[i];
    // }
    throw UnimplementedError();
  }
}
