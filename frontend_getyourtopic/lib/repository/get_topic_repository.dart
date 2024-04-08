import 'package:frontend_getyourtopic/model/get_topic.dart';

abstract class GetTopicRepository {
  Future<GetTopic> getTopic(String prompt, {String? pictureBase64});

  Stream<String> getTopicStream(String prompt, {String? pictureBase64});
}
