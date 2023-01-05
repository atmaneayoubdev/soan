class CategoryModel {
  String name;
  String id;
  String image;

  CategoryModel({
    required this.name,
    required this.id,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
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
