class ColorModel {
  String name;
  String id;

  ColorModel({
    required this.name,
    required this.id,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) => ColorModel(
        name: json["name"].toString(),
        id: json["id"].toString(),
      );
}
