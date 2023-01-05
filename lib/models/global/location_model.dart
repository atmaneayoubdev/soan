import 'package:soan/models/global/city_model.dart';
import 'package:soan/models/global/region_model.dart';

class LocationModel {
  String addressName;
  String locationName;
  RegionModel region;
  String lat;
  String lng;
  CityModel city;

  LocationModel({
    required this.addressName,
    required this.locationName,
    required this.region,
    required this.lat,
    required this.lng,
    required this.city,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        addressName: json["address_name"].toString(),
        locationName: json["location_name"].toString(),
        region: RegionModel.fromJson(json["region"]),
        lat: json["lat"].toString(),
        lng: json["lng"].toString(),
        city: CityModel.fromJson(json["city"]),
      );
}
