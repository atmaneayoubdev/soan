class InvoiceItemModel {
  String name;
  String id;
  String price;

  InvoiceItemModel({
    required this.name,
    required this.id,
    required this.price,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      InvoiceItemModel(
        name: json["name"].toString(),
        id: json["id"].toString(),
        price: json["price"].toString(),
      );
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
    };
  }
}
