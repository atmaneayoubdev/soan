class InfoModel {
  String appName;
  String phone;
  String whatsapp;
  String vat;
  String dues;
  String email;

  InfoModel({
    required this.appName,
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.vat,
    required this.dues,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
        appName: json["facebook"].toString(),
        phone: json["phone"].toString(),
        whatsapp: json["whatsapp"].toString(),
        email: json["email"].toString(),
        vat: json["vat"].toString(),
        dues: json["dues"].toString(),
      );
}
