class ImageModel {
  String image;
  String id;

  ImageModel({
    required this.image,
    required this.id,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        image: json["image"].toString(),
        id: json["id"].toString(),
      );
  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "id": id,
    };
  }
}
