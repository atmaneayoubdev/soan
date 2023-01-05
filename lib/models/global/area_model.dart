class AreaModel {
  String name;
  String id;

  AreaModel({
    required this.name,
    required this.id,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
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
