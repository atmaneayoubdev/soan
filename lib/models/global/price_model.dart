class PriceModel {
  String subTotal;
  String vat;
  String total;

  PriceModel({
    required this.subTotal,
    required this.vat,
    required this.total,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) => PriceModel(
        subTotal: json["sub_total"].toString(),
        vat: json["vat"].toString(),
        total: json["total"].toString(),
      );
}
