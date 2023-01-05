import 'package:soan/models/global/answer_list_model.dart';

class AnswerModel {
  String acceptAnswer;
  String acceptCout;
  List<AnswerListModel> answersList;
  AnswerListModel? accept;

  AnswerModel({
    required this.acceptAnswer,
    required this.acceptCout,
    required this.answersList,
    required this.accept,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
        acceptAnswer: json["accept_answer"].toString(),
        acceptCout: json["answer_count"].toString(),
        accept: json["accept"].isNotEmpty
            ? AnswerListModel.fromJson(json["accept"])
            : null,
        answersList: (json['lists'] as List)
            .map((x) => AnswerListModel.fromJson(x))
            .toList(),
      );
}
