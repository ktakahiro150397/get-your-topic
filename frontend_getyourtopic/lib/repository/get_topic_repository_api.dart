import 'dart:convert';

import 'package:frontend_getyourtopic/model/get_topic.dart';
import 'package:frontend_getyourtopic/repository/get_topic_repository.dart';
import 'package:http/http.dart' as http;

class GetTopicRepositoryAPI extends GetTopicRepository {
  static const String ENDPOINT = "http://backend:8000";

  @override
  Future<GetTopic> getTopic(String prompt) async {
    final body = {
      "apikey": "",
      "prompt": prompt,
      "picture_base64": "",
      "dry_run": false,
    };

    final endpointUri = Uri.http("backend:8000", "getTopic/");
    final response =
        await http.post(endpointUri, body: jsonEncode(body), headers: {
      "accept": "application/json",
      "Content-Type": "application/json",
    });

    if (response.statusCode != 200) {
      return GetTopic.fromErrorJson(jsonDecode(response.body));
    } else {
      return GetTopic.fromJson(
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));
    }
  }
}