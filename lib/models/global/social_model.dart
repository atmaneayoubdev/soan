class SocialModel {
  String facebook;
  String instagram;
  String twitter;

  SocialModel({
    required this.facebook,
    required this.instagram,
    required this.twitter,
  });

  factory SocialModel.fromJson(Map<String, dynamic> json) => SocialModel(
        facebook: json["facebook"].toString(),
        instagram: json["instagram"].toString(),
        twitter: json["twitter"].toString(),
      );
}
