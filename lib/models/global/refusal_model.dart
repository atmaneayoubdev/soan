class RefusalModel {
  String name;
  String id;

  RefusalModel({
    required this.name,
    required this.id,
  });

  factory RefusalModel.fromJson(Map<String, dynamic> json) => RefusalModel(
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
