import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/auth/user_model.dart';
import 'package:soan/models/constumer/car_model.dart';
import 'package:soan/models/global/categories_model.dart';
import 'package:soan/models/global/image_model.dart';
import 'package:soan/models/global/inoice_item_model.dart';
import 'package:soan/models/global/location_model.dart';
import 'package:soan/models/global/price_model.dart';
import 'package:soan/models/provider/p_answer_model.dart';

class PorderModel {
  String id;
  String costumerRate;
  String createdAt;
  String orderStatus;
  String orderPlace;
  LocationModel location;
  String description;
  PriceModel price;
  String dues;
  UserModel costumer;
  ProviderModel? provider;
  CarModel? car;
  CategoryModel category;
  List<InvoiceItemModel> invoiceItems;
  String invoiceMessage;
  List<ImageModel> images;
  String processAt;
  String completedAt;
  PanswerModel answer;

  PorderModel({
    required this.id,
    required this.costumerRate,
    required this.createdAt,
    required this.orderStatus,
    required this.orderPlace,
    required this.location,
    required this.description,
    required this.price,
    required this.dues,
    required this.costumer,
    required this.provider,
    required this.car,
    required this.category,
    required this.invoiceItems,
    required this.invoiceMessage,
    required this.images,
    required this.processAt,
    required this.answer,
    required this.completedAt,
  });

  factory PorderModel.fromJson(Map<String, dynamic> json) => PorderModel(
        id: json["id"].toString(),
        costumerRate: json["customer_rate"].toString(),
        createdAt: json["created_at"].toString(),
        orderStatus: json["order_status"].toString(),
        orderPlace: json["order_place"].toString(),
        location: LocationModel.fromJson(json["location"]),
        description: json["description"].toString(),
        price: PriceModel.fromJson(json["prices"]),
        dues: json["dues"].toString(),
        costumer: UserModel.fromJson(json["customer"]),
        provider: json['provider'].runtimeType == (List<dynamic>)
            ? null
            : ProviderModel.fromJson(json['provider']),
        car: json["car"].isEmpty ? null : CarModel.fromJson(json["car"]),
        category: CategoryModel.fromJson(json["category"]),
        invoiceItems: (json["invoice_items"] as List)
            .map((x) => InvoiceItemModel.fromJson(x))
            .toList(),
        invoiceMessage: json["invoice_items_message"].toString(),
        images: json["images"].isEmpty
            ? []
            : (json["images"] as List)
                .map((x) => ImageModel.fromJson(x))
                .toList(),
        processAt: json["process_at"].toString(),
        completedAt: json["completed_at"].toString(),
        answer: PanswerModel.fromJson(json["answers"]),
      );
}
