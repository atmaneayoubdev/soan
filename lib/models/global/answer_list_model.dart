import 'package:soan/models/auth/provider_model.dart';

class AnswerListModel {
  String accept;
  String id;
  String createdAt;
  String orderId;
  String answer;
  ProviderModel provider;

  AnswerListModel({
    required this.accept,
    required this.id,
    required this.createdAt,
    required this.orderId,
    required this.provider,
    required this.answer,
  });

  factory AnswerListModel.fromJson(Map<String, dynamic> json) =>
      AnswerListModel(
        accept: json["name"].toString(),
        id: json["id"].toString(),
        answer: json["answer"].toString(),
        createdAt: json["created_at"].toString(),
        orderId: json["order_id"].toString(),
        provider: ProviderModel.fromJson(json["provider_id"]),
      );
}
