class CarCountryFactoryModel {
  String name;
  String id;

  CarCountryFactoryModel({
    required this.name,
    required this.id,
  });

  factory CarCountryFactoryModel.fromJson(Map<String, dynamic> json) =>
      CarCountryFactoryModel(
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
