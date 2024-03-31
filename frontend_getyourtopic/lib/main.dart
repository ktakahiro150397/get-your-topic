import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend_getyourtopic/component/primary_button.dart';
import 'package:frontend_getyourtopic/component/primary_button_loadable.dart';
import 'package:frontend_getyourtopic/component/topic_result.dart';
import 'package:frontend_getyourtopic/repository/get_topic_repository.dart';
import 'package:frontend_getyourtopic/repository/get_topic_repository_test.dart';

void main() {
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

  @override
  void initState() {
    super.initState();
    topicRepo = GetTopicRepositoryTest();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("今の状況を教えてください。コミュ障のあなたに代わってAIが最適な話題を考えてくれます。"),
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
              PrimaryButtonLoadable(
                isLoading: isLoading,
                loadingWidget: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(width: 8),
                    Text("話題を考えています..."),
                  ],
                ),
                title: "話題を提案してもらう",
                height: 50,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final response =
                      await topicRepo.getTopic(promptController.text);

                  setState(() {
                    isLoading = false;
                    topicResponse = response;
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              TopicResult(
                isLoading: false,
                result: topicResponse,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
