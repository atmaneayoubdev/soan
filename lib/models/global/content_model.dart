class ContentModel {
  String title;
  String id;
  String image;

  ContentModel({
    required this.title,
    required this.id,
    required this.image,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
        title: json["title"].toString(),
        id: json["id"].toString(),
        image: json["image"].toString(),
      );
}
