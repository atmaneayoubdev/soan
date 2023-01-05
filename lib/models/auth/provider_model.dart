import 'package:soan/models/global/car_country_factory_model.dart';
import 'package:soan/models/global/categories_model.dart';
import 'package:soan/models/global/city_model.dart';
import 'package:soan/models/global/how_to_know_us_model.dart';
import 'package:soan/models/global/region_model.dart';

class ProviderModel {
  String id;
  String providerName;
  String phone;
  String email;
  HowToKnowUsModel howToKnowUs;
  String commercialRegistrationNumber;
  String taxNumber;
  RegionModel region;
  CityModel city;
  String lat;
  String lng;
  String terms;
  String avatar;
  String rates;
  String ratesCount;
  List<CategoryModel> categories;
  List<CarCountryFactoryModel> carCountryFactories;
  String apiToken;
  String approved;

  ProviderModel({
    required this.id,
    required this.providerName,
    required this.phone,
    required this.commercialRegistrationNumber,
    required this.taxNumber,
    required this.lat,
    required this.lng,
    required this.terms,
    required this.rates,
    required this.ratesCount,
    required this.apiToken,
    required this.avatar,
    required this.email,
    required this.carCountryFactories,
    required this.categories,
    required this.city,
    required this.howToKnowUs,
    required this.region,
    required this.approved,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
        id: json["id"].toString(),
        providerName: json["provider_name"].toString(),
        phone: json["phone"].toString(),
        commercialRegistrationNumber:
            json["commercial_registration_number"].toString(),
        taxNumber: json["tax_number"].toString(),
        avatar: json["avatar"].toString(),
        email: json["email"].toString(),
        lat: json["lat"].toString(),
        lng: json["lng"].toString(),
        terms: json["terms"].toString(),
        rates: json["rates"].toString(),
        ratesCount: json["rates_count"].toString(),
        apiToken: json["api_token"].toString(),
        carCountryFactories: (json['carCountryFactories'] as List)
            .map((x) => CarCountryFactoryModel.fromJson(x))
            .toList(),
        categories: (json['categories'] as List)
            .map((x) => CategoryModel.fromJson(x))
            .toList(),
        city: json['city'].isEmpty
            ? CityModel(name: '', id: '')
            : CityModel.fromJson(json['city']),
        howToKnowUs: HowToKnowUsModel.fromJson(json['how_to_know_us']),
        region: json["region"].isEmpty
            ? RegionModel(name: '', id: '')
            : RegionModel.fromJson(json['region']),
        approved: json['admin_approved'].toString(),
      );
}
