class HomesliderModel {
  String name;
  String id;
  String image;

  HomesliderModel({
    required this.name,
    required this.id,
    required this.image,
  });

  factory HomesliderModel.fromJson(Map<String, dynamic> json) =>
      HomesliderModel(
        name: json["name"].toString(),
        id: json["id"].toString(),
        image: json["image"].toString(),
      );
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "image": image,
    };
  }
}
