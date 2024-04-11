import 'package:frontend_getyourtopic/model/get_topic.dart';
import 'package:http/http.dart';

abstract class GetTopicRepository {
  Future<GetTopic> getTopic(String prompt, {String? pictureBase64});

  Future<ByteStream> getTopicStream(String prompt, {String? pictureBase64});
}
