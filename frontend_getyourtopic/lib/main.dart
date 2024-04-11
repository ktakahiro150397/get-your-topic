import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend_getyourtopic/component/primary_button.dart';
import 'package:frontend_getyourtopic/component/primary_button_loadable.dart';
import 'package:frontend_getyourtopic/component/topic_result.dart';
import 'package:frontend_getyourtopic/model/get_topic.dart';
import 'package:frontend_getyourtopic/repository/get_topic_repository.dart';
import 'package:frontend_getyourtopic/repository/get_topic_repository_api.dart';
import 'package:image_picker_web/image_picker_web.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Your Topic!',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        fontFamily: "MPlus1P",
      ),
      home: const MyHomePage(title: '話題考えてあげるちゃん'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final promptController = TextEditingController();
  late final GetTopicRepository topicRepo;

  TopicResult topicResult = const TopicResult();
  String topicResponse = "";
  bool isLoading = false;
  bool isResponseOK = false;
  bool isResponseComplete = false;

  Uint8List? imageBytes;
  String base64WithScheme = "";

  void Function()? onPressedGetResponse;

  Widget getUploadPicture() {
    if (imageBytes == null) {
      return const SizedBox();
    } else {
      return Stack(alignment: Alignment.center, children: [
        SizedBox(width: 150, height: 150, child: Image.memory(imageBytes!)),
        Positioned(
          right: 10,
          top: 10,
          child: IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: "画像を削除します",
            onPressed: () {
              setState(() {
                imageBytes = null;
              });
            },
          ),
        ),
      ]);
    }
  }

  bool validate() {
    if (promptController.text.isNotEmpty) {
      return true;
    }

    if (imageBytes != null && imageBytes!.isNotEmpty) {
      return true;
    }

    return false;
  }

  void onPressedGetStreamingResponse() async {
    final isValid = validate();

    if (!isValid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("エラー"),
              content: const Text("文章か画像で今の状況を教えてください！"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            );
          });
      return;
    }

    setState(() {
      isLoading = true;
    });
    //await getResponseStream();
    getResponseStream();
  }

  Future<GetTopic> postLLMAPI() async {
    final response = await topicRepo.getTopic(promptController.text,
        pictureBase64: base64WithScheme);

    return response;
  }

  void getResponseStream() {
    topicResponse = "";

    setState(() {
      isResponseComplete = false;
      onPressedGetResponse = null;
    });

    var stream = topicRepo.getTopicStream(promptController.text,
        pictureBase64: base64WithScheme);

    var isBlankStreak = false;
    stream.asStream().listen((event) {
      event
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen(
        (dataLine) {
          var lineRegex = RegExp(r'^([^:]*)(?::)?(?: )?(.*)?$');

          ///Get the match of each line through the regex
          Match match = lineRegex.firstMatch(dataLine)!;
          var field = match.group(1);
          if (field!.isEmpty) {
            return;
          }
          var value = '';
          if (field == "data") {
            //If the field is data, we get the data through the substring
            value = dataLine.substring(
              6,
            );

            if (value.isEmpty) {
              if (isBlankStreak) {
                value += "\n";
                isBlankStreak = false;
              } else {
                isBlankStreak = true;
              }
            }

            setState(() {
              isResponseOK = true;
              topicResponse += value;
            });
          }
        },
        onDone: () {
          setState(() {
            isResponseComplete = true;
            onPressedGetResponse = onPressedGetStreamingResponse;
            isLoading = false;
          });
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    topicRepo = GetTopicRepositoryAPI();
    //topicRepo = GetTopicRepositoryTest();

    onPressedGetResponse = onPressedGetStreamingResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const Text("今の状況を教えてください。\nコミュ障のあなたに代わってAIが最適な話題を考えてくれます。"),
              const SizedBox(height: 16),
              TextField(
                controller: promptController,
                maxLines: 3,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: const InputDecoration(
                    labelText: 'どんな状況で話題がないですか？',
                    hintText:
                        "(入力例)上司と2人でビジネス街を歩いている。\n周りは人通りが少なく、駐車場くらいしかない。\n最近仕事でミスったのでちょっと気まずい。",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                title: "画像を添付する",
                hintText: "今の状況を画像で教えてください！",
                onPressed: () async {
                  final mediaData = await ImagePickerWeb.getImageInfo;

                  if (mediaData != null) {
                    setState(() {
                      base64WithScheme = mediaData.base64WithScheme!;
                      imageBytes = mediaData.data;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              getUploadPicture(),
              const Divider(),
              const SizedBox(height: 8),
              PrimaryButtonLoadable(
                title: "話題を提案してもらう！",
                height: 50,
                onPressed: onPressedGetResponse,
                isLoading: isLoading,
              ),
              const SizedBox(
                height: 16,
              ),
              TopicResult(
                isResponseOK: isResponseOK,
                result: topicResponse,
                isResponseComplete: isResponseComplete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
