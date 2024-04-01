class GetTopic {
  final String model;
  final String response;

  GetTopic({required this.model, required this.response});

  factory GetTopic.fromJson(Map<String, dynamic> json) {
    return GetTopic(
      model: json['model'],
      response: json['response'],
    );
  }

  factory GetTopic.fromErrorJson(Map<String, dynamic> json) {
    return GetTopic(
      model: "",
      response: json['detail'],
    );
  }

  String get responseContent {
    return "$response\n\n使用した生成AIModel : $model";
  }
}
