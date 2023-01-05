class DuesOrderModel {
  String id;
  String createdAt;
  String orderCost;
  String dues;

  DuesOrderModel({
    required this.id,
    required this.createdAt,
    required this.orderCost,
    required this.dues,
  });

  factory DuesOrderModel.fromJson(Map<String, dynamic> json) => DuesOrderModel(
        id: json["id"].toString(),
        createdAt: json["created_at"].toString(),
        orderCost: json["order_cost"].toString(),
        dues: json["dues"].toString(),
      );
}
