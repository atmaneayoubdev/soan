import 'package:soan/models/global/answer_list_model.dart';

class PanswerModel {
  String makeAnswer;
  AnswerListModel? answer;

  PanswerModel({
    required this.makeAnswer,
    required this.answer,
  });

  factory PanswerModel.fromJson(Map<String, dynamic> json) => PanswerModel(
        makeAnswer: json["make_answer"].toString(),
        answer: json["answer"].isEmpty
            ? null
            : AnswerListModel.fromJson(json["answer"]),
      );
}
