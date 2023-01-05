import 'package:soan/models/global/car_country_factory_model.dart';
import 'package:soan/models/global/color_model.dart';

class CarModel {
  String id;
  ColorModel color;
  CarCountryFactoryModel carCountryFactory;
  String vin;
  String vds;
  String manufacturer;
  String modelYear;

  CarModel({
    required this.id,
    required this.color,
    required this.carCountryFactory,
    required this.vin,
    required this.vds,
    required this.manufacturer,
    required this.modelYear,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json["id"].toString(),
        color: ColorModel.fromJson(json["color"]),
        carCountryFactory:
            CarCountryFactoryModel.fromJson(json["car_country_factory"]),
        vin: json["vin"].toString(),
        vds: json["vds"].toString(),
        manufacturer: json["manufacturer"].toString(),
        modelYear: json['modelYear'].toString(),
      );
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "color": color,
      "car_country_factory": carCountryFactory,
      "vin": vin,
      "manufacturer": manufacturer,
      'vds': vds,
      'modelYear': modelYear,
    };
  }
}
