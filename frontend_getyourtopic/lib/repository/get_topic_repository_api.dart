import 'dart:convert';
import 'dart:async';

import 'package:frontend_getyourtopic/model/get_topic.dart';
import 'package:frontend_getyourtopic/repository/get_topic_repository.dart';
import 'package:frontend_getyourtopic/sse_stream_web.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GetTopicRepositoryAPI extends GetTopicRepository {
  final apiServerUrl = const String.fromEnvironment("API_SERVER");

  @override
  Future<GetTopic> getTopic(String prompt, {String? pictureBase64}) async {
    final body = {
      "apikey": "",
      "prompt": prompt,
      "picture_base64": pictureBase64,
      "dry_run": false,
    };

    final endpointUri = Uri.http(apiServerUrl, "/getTopic/");
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

  @override
  Future<ByteStream> getTopicStream(String prompt, {String? pictureBase64}) {
    const apiServerUrl = String.fromEnvironment("API_SERVER");
    final endpointUri = Uri.http(apiServerUrl, "/getTopicStream/");
    final body = {
      "apikey": "",
      "prompt": prompt,
      "picture_base64": pictureBase64,
      "dry_run": false,
    };
    final header = {
      'accept': 'text/event-stream',
      "Content-Type": "application/json",
    };

    var request = http.Request(
      "POST",
      endpointUri,
    );
    header.forEach((key, value) {
      request.headers[key] = value;
    });
    request.body = jsonEncode(body);
    request.persistentConnection = false;

    return getStream(request);
  }

  Stream<String> convertResponseStreamToStringStream(
      Stream<List<int>> responseStream) async* {
    await for (var chunk in responseStream) {
      yield utf8.decode(chunk);
    }
  }
}
