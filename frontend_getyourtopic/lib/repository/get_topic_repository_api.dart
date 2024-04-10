import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:frontend_getyourtopic/model/get_topic.dart';
import 'package:frontend_getyourtopic/repository/get_topic_repository.dart';
import 'package:http/http.dart' as http;

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
  // Future<Stream<String>> getTopicStream(String prompt,
  Stream<String> getTopicStream(String prompt, {String? pictureBase64}) async* {
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

    Stream<SSEModel> stream = SSEClient.subscribeToSSE(
        method: SSERequestType.POST,
        url: endpointUri.toString(),
        header: header,
        body: body);

    stream.listen((event) {
      print(event);
    });

    // final client = HttpClient();

    // HttpClientRequest request = await client.postUrl(endpointUri);
    // header.forEach((key, value) {
    //   request.headers.add(key, value);
    // });
    // request.add(utf8.encode(jsonEncode(body)));

    // HttpClientResponse response = await request.close();

    // final content = await response.transform(utf8.decoder).join();
    // print(content);

    // client.close();

    // final request = http.Request(
    //   "POST",
    //   endpointUri,
    // );

    // header.forEach((key, value) {
    //   request.headers[key] = value;
    // });
    // request.body = jsonEncode(body);
    // // Future<http.StreamedResponse> response = client.send(request);
    // http.StreamedResponse response = await client.send(request);

    // final _controller = StreamController<String>();

    // // final awaited = await response;
    // response.stream.listen((value) {
    //   print(value);
    // });
    //final resStream = response.asStream();

    // resStream.listen((event) async {
    //   final content = await event.stream.bytesToString();
    //   print(event);
    //   print(content);
    // });

    await Future.delayed(const Duration(seconds: 30));

    // response.asStream().listen((event) {
    //   _controller.sink.add("<data>");
    // });

    // await for (var chunk in response.asStream()) {
    //   yield chunk.toString();
    // }

    // await for (var chunk in response.asStream()) {
    //   final content = chunk.stream.bytesToString();
    //   print(content);
    // }

    throw UnimplementedError();

    //response.asStream().transform(Utf8.);
  }

  Stream<String> convertResponseStreamToStringStream(
      Stream<List<int>> responseStream) async* {
    await for (var chunk in responseStream) {
      yield utf8.decode(chunk);
    }
  }
}
