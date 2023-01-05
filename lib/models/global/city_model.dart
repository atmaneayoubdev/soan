class CityModel {
  String name;
  String id;

  CityModel({
    required this.name,
    required this.id,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        name: json["name"].toString(),
        id: json["id"].toString(),
      );
}
