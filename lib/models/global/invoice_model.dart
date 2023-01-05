import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/auth/user_model.dart';
import 'package:soan/models/global/inoice_item_model.dart';
import 'package:soan/models/global/location_model.dart';
import 'package:soan/models/global/price_model.dart';

class InvoiceModel {
  String id;
  String createdAt;
  LocationModel locaiton;
  PriceModel prices;
  List<InvoiceItemModel> invoiceItems;
  UserModel customer;
  ProviderModel provider;

  InvoiceModel({
    required this.id,
    required this.createdAt,
    required this.locaiton,
    required this.prices,
    required this.invoiceItems,
    required this.customer,
    required this.provider,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["id"].toString(),
        createdAt: json["created_at"].toString(),
        locaiton: LocationModel.fromJson(json["location"]),
        prices: PriceModel.fromJson(json["prices"]),
        invoiceItems: (json["invoice_items"] as List)
            .map((x) => InvoiceItemModel.fromJson(x))
            .toList(),
        customer: UserModel.fromJson(json["customer"]),
        provider: ProviderModel.fromJson(json["provider"]),
      );
}
