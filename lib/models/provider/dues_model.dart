import 'package:soan/models/provider/dues_order_model.dart';

class DuesModel {
  String dues;
  List<DuesOrderModel> orders;

  DuesModel({
    required this.dues,
    required this.orders,
  });

  factory DuesModel.fromJson(Map<String, dynamic> json) => DuesModel(
        dues: json["dues"].toString(),
        orders: (json['orders'] as List)
            .map((x) => DuesOrderModel.fromJson(x))
            .toList(),
      );
}
