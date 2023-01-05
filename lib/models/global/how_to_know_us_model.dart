class HowToKnowUsModel {
  String name;
  String id;

  HowToKnowUsModel({
    required this.name,
    required this.id,
  });

  factory HowToKnowUsModel.fromJson(Map<String, dynamic> json) =>
      HowToKnowUsModel(
        name: json["name"].toString(),
        id: json["id"].toString(),
      );
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
    };
  }
}
