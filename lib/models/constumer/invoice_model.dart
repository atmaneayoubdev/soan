import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/auth/user_model.dart';
import 'package:soan/models/global/inoice_item_model.dart';
import 'package:soan/models/global/location_model.dart';
import 'package:soan/models/global/price_model.dart';

class OrderModel {
  String id;
  String createdAt;
  LocationModel location;
  PriceModel price;
  List<InvoiceItemModel> invoiceItems;
  UserModel costumer;
  ProviderModel? provider;

  OrderModel({
    required this.id,
    required this.createdAt,
    required this.location,
    required this.price,
    required this.costumer,
    required this.provider,
    required this.invoiceItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"].toString(),
        createdAt: json["created_at"].toString(),
        location: LocationModel.fromJson(json["location"]),
        price: PriceModel.fromJson(json["prices"]),
        costumer: UserModel.fromJson(json["customer"]),
        provider: json['provider'].runtimeType == (List<dynamic>)
            ? null
            : ProviderModel.fromJson(json['provider']),
        invoiceItems: (json["invoice_items"] as List)
            .map((x) => InvoiceItemModel.fromJson(x))
            .toList(),
      );
}
