class RegionModel {
  String name;
  String id;

  RegionModel({
    required this.name,
    required this.id,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
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
