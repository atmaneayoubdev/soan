import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:soan/constants.dart';
import 'package:soan/models/global/area_model.dart';
import 'package:soan/models/global/car_country_factory_model.dart';
import 'package:soan/models/global/categories_model.dart';
import 'package:soan/models/global/city_model.dart';
import 'package:soan/models/global/color_model.dart';
import 'package:soan/models/global/content_model.dart';
import 'package:soan/models/global/how_to_know_us_model.dart';
import 'package:soan/models/global/refusal_model.dart';
import 'package:soan/models/global/settings_model.dart';
import 'package:soan/models/global/slider_model.dart';

class GlobalController with ChangeNotifier {
  ////////////////////get categories//////////////////////
  static Future<List<CategoryModel>> getCategories(String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}categories",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<CategoryModel> categories = [];
        categories = (response.data['data'] as List)
            .map((x) => CategoryModel.fromJson(x))
            .toList();
        return categories;
      }
      return [];
    } on DioError {
      //debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get country factories//////////////////////
  static Future<List<CarCountryFactoryModel>> getCarCountryFactories(
      String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}car-country-factories",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<CarCountryFactoryModel> factories = [];
        factories = (response.data['data'] as List)
            .map((x) => CarCountryFactoryModel.fromJson(x))
            .toList();
        return factories;
      }
      return [];
    } on DioError {
      //debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get areas//////////////////////
  static Future<List<AreaModel>> getAreaList(String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}areas",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<AreaModel> areas = [];
        areas = (response.data['data'] as List)
            .map((x) => AreaModel.fromJson(x))
            .toList();
        return areas;
      }
      return [];
    } on DioError {
      //debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get area cities//////////////////////
  static Future<List<CityModel>> getAreaCities(int id, String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}areas/$id",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<CityModel> cities = [];
        cities = (response.data['data'] as List)
            .map((x) => CityModel.fromJson(x))
            .toList();
        return cities;
      }
      return [];
    } on DioError {
      //debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get how to know us//////////////////////
  static Future<List<HowToKnowUsModel>> getHowToKnowUsList(
      String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}knowUs",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<HowToKnowUsModel> howToknowUsList = [];
        howToknowUsList = (response.data['data'] as List)
            .map((x) => HowToKnowUsModel.fromJson(x))
            .toList();
        return howToknowUsList;
      }
      return [];
    } on DioError {
      //debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get sliders list//////////////////////
  static Future<List<HomesliderModel>> getSlidersList(String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}sliders",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<HomesliderModel> sliders = [];
        sliders = (response.data['data'] as List)
            .map((x) => HomesliderModel.fromJson(x))
            .toList();
        return sliders;
      }
      return [];
    } on DioError {
      //debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get settings//////////////////////
  static Future getSettings(String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();
      var response = await dio.get(
        "${baseUrl}settings",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        SettingsModel settings;
        settings = SettingsModel.fromJson(response.data['data']);
        return settings;
      }
    } on DioError {
      //debugPrint(error.message!);
      return;
    }
  }

  ////////////////////get colors//////////////////////
  static Future<List<ColorModel>> getColors(String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}car-colors",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<ColorModel> colors = [];
        colors = (response.data['data'] as List)
            .map((x) => ColorModel.fromJson(x))
            .toList();
        return colors;
      }
      return [];
    } on DioError {
      //debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get makers//////////////////////
  static Future<List<String>> getMakers(String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}cars-get-make",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<String> makers = [];
        makers = (response.data['data'] as List<dynamic>).cast<String>();

        return makers;
      }
      return [];
    } on DioError {
      //debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get models//////////////////////
  static Future<List<String>> getModels(String maker, String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}cars-get-models/$maker",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<String> models = [];
        models = (response.data['data'] as List<dynamic>).cast<String>();
        return models;
      }
      return [];
    } on DioError {
      //debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get colors//////////////////////
  static Future<List<RefusalModel>> getRefualList(String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}refusals",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<RefusalModel> refusals = [];
        refusals = (response.data['data'] as List)
            .map((x) => RefusalModel.fromJson(x))
            .toList();
        return refusals;
      }
      return [];
    } on DioError {
      //debugPrint(error.message!);
      return [];
    }
  }

  //////////////////// send message //////////////////////
  static Future sendMessage({
    required String token,
    required String message,
    required String type,
    required String language,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.post(
        "${baseUrl}send-message",
        data: {
          "message": message,
          "message_type": type,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      if (response.statusCode == 400) {
        return {
          "message": response.data["errors"].first["value"],
          "code": response.statusCode.toString()
        };
      }
      return {
        "message": response.data["message"].toString(),
        "code": response.statusCode.toString()
      };
    } on DioError catch (error) {
      //debugPrint(error.message!);
      return error.message!;
    }
  }

  ////////////////////get privacy//////////////////////
  static Future<String> getContentInfo(String language, String id) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();
      var response = await dio.get(
        "${baseUrl}contents/$id",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      return response.data['data']['description'];
    } on DioError {
      //debugPrint(error.message!);
      return '';
    }
  }

  ////////////////////get privacy//////////////////////
  static Future getContents(String language) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
      };
      Dio dio = Dio();
      var response = await dio.get(
        "${baseUrl}contents",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      //debugPrint(response.data.toString());
      return (response.data['data'] as List)
          .map((x) => ContentModel.fromJson(x))
          .toList();
    } on DioError {
      //debugPrint(error.message!);
      return '';
    }
  }
}
