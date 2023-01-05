import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soan/constants.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/auth/user_model.dart';
import 'package:soan/models/constumer/car_model.dart';
import 'package:soan/models/constumer/notification_model.dart';
import 'package:soan/models/constumer/order_model.dart';
import 'package:soan/models/global/answer_list_model.dart';
import 'package:soan/models/global/invoice_model.dart';

class CostumerController with ChangeNotifier {
  ////////////////////////////change user info///////////////////////////
  static Future updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    File? image,
  }) async {
    Dio dio = Dio();
    Map<String, String> headers = {
      'Content-type': 'multipart/from-data',
      "Accept": "application/json",
      'Authorization': "Bearer $token",
    };

    if (image != null) {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        'first_name': firstName,
        "last_name": lastName,
        "avatar": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      var response = await dio.post(
        "${baseUrl}customer/my-profile",
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      UserModel user;
      user = UserModel.fromJson(response.data["data"]);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('firstName', user.firstName);
      prefs.setString('lastName', user.lastName);
      prefs.setString('phone', user.phoneNumber);
      prefs.setString('api_token', token);
      prefs.setString('avatar', user.avatar);
      prefs.setString('email', user.email);
      prefs.setString('type', '1');
      user.apiToken = token;
      return user;
    } else {
      FormData formData = FormData.fromMap({
        'first_name': firstName,
        "last_name": lastName,
      });
      var response = await dio.post(
        "${baseUrl}customer/my-profile",
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      UserModel user;
      user = UserModel.fromJson(response.data["data"]);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('firstName', user.firstName);
      prefs.setString('lastName', user.lastName);
      prefs.setString('phone', user.phoneNumber);
      prefs.setString('api_token', token);
      prefs.setString('avatar', user.avatar);
      prefs.setString('email', user.email);
      prefs.setString('type', '1');
      user.apiToken = token;
      return user;
    }
  }

  ////////////////////////////change user phone///////////////////////////
  static Future updatePhone({
    required String token,
    required String phone,
    required String password,
  }) async {
    try {
      Dio dio = Dio();
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
      };
      log(password);
      log(phone);
      var response = await dio.post(
        "${baseUrl}customer/my-profile/change-phone",
        data: {
          "phone": phone,
          "password": password,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        prefs.setString('phone', phone);

        return response.data['message'];
      } else {
        return response.data['message'] == 'Invalid data'
            ? response.data['errors'].first['value']
            : response.data['message'];
      }
    } on DioError catch (error) {
      log(error.message);
      return error.response!.data['message'];
    }
  }

  ////////////////////////////change user password///////////////////////////
  static Future updatePassword({
    required String token,
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      Dio dio = Dio();
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
      };

      var response = await dio.post(
        "${baseUrl}customer/my-profile/change-password",
        data: {
          "old_password": oldPassword,
          "password": password,
          "password_confirmation": passwordConfirmation,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        return response.data['message'] == 'Invalid data'
            ? response.data['errors'].first['value']
            : response.data['message'];
      }
    } on DioError catch (error) {
      log(error.message);
      return error.response!.data['message'];
    }
  }

  ////////////////////get my cars list//////////////////////
  static Future<List<CarModel>> getCostumerCars(String token) async {
    try {
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}customer/my-cars",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        List<CarModel> cars = [];
        cars = (response.data['data'] as List)
            .map((x) => CarModel.fromJson(x))
            .toList();
        return cars;
      }
      return [];
    } on DioError catch (error) {
      log(error.message);
      return [];
    }
  }

  //////////////////////////////delete costumer car//////////////////////

  static Future deleteCar({
    required String token,
    required int id,
  }) async {
    try {
      Dio dio = Dio();
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
      };

      var response = await dio.delete(
        "${baseUrl}customer/my-cars/$id",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        return response.data['message'];
      }
      return response.data['message'];
    } on DioError catch (error) {
      log(error.message);
      return error.response!.data['message'];
    }
  }

  ////////////////////////////add car///////////////////////////
  static Future addCar({
    required String token,
    required String carFactoryId,
    required String colorId,
    required String make,
    required String models,
    required String year,
    required String vin,
  }) async {
    try {
      Dio dio = Dio();
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
      };

      var response = await dio.post(
        "${baseUrl}customer/my-cars",
        data: {
          "car_country_factory_id": carFactoryId,
          "color_id": colorId,
          "make": make,
          "models": models,
          "year": year,
          "vin": vin
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        CarModel car = CarModel.fromJson(response.data["data"]);
        return car;
      } else {
        return response.data['message'] == 'Invalid data'
            ? response.data['errors'].first['value']
            : response.data['message'];
      }
    } on DioError catch (error) {
      log(error.message);
      return error.response!.data['message'];
    }
  }

  ////////////////////////////add car///////////////////////////
  static Future updateCar({
    required String token,
    required String carFactoryId,
    required String colorId,
    required String make,
    required String models,
    required String year,
    required String vin,
    required int id,
  }) async {
    try {
      Dio dio = Dio();
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
      };

      var response = await dio.put(
        "${baseUrl}customer/my-cars/$id",
        data: {
          "car_country_factory_id": carFactoryId,
          "color_id": colorId,
          "make": make,
          "models": models,
          "year": year,
          "vin": vin
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        CarModel car = CarModel.fromJson(response.data["data"]);
        return car;
      } else {
        return response.data['message'] == 'Invalid data'
            ? response.data['errors'].first['value']
            : response.data['message'];
      }
    } on DioError catch (error) {
      log(error.message);
      return error.response!.data['message'];
    }
  }

  ////////////////////get how to know us//////////////////////
  static Future<List<NotificationModel>> getNotifications(
      {required String language, required String token}) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Accept-Language': language,
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}customer/notifications",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        List<NotificationModel> notifications = [];
        notifications = (response.data['data'] as List)
            .map((x) => NotificationModel.fromJson(x))
            .toList();
        return notifications;
      }
      return [];
    } on DioError catch (error) {
      log(error.message);
      return [];
    }
  }

  ////////////////////get providers list//////////////////////
  static Future<List<ProviderModel>> getProvidersList({
    required String token,
    required bool isNear,
    required String categoryId,
    LatLng? latLng,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.post(
        "${baseUrl}customer/get-providers",
        data: isNear
            ? {
                "category_id": categoryId,
                "search_by": "near",
                "lat": latLng!.latitude,
                "lng": latLng.longitude,
              }
            : {
                "category_id": categoryId,
                "search_by": "top_rate",
              },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        List<ProviderModel> notifications = [];
        notifications = (response.data['data'] as List)
            .map((x) => ProviderModel.fromJson(x))
            .toList();
        return notifications;
      }
      return [];
    } on DioError catch (error) {
      log(error.message);
      return [];
    }
  }

  ////////////////////////////create order///////////////////////////
  static Future createOrder({
    required String token,
    required String carId,
    required String catId,
    required String adressName,
    required String locationName,
    required String lat,
    required String lng,
    required String orderPlace,
    required String desc,
    required String regionId,
    required String cityId,
    required List<File?> images,
  }) async {
    Dio dio = Dio();
    Map<String, String> headers = {
      'Content-type': 'multipart/from-data',
      "Accept": "application/json",
      'Authorization': "Bearer $token",
    };

    //String fileName = image.path.split('/').last;
    List<MultipartFile> imagesList = [];
    for (var image in images) {
      if (image != null) {
        String fileName = image.path.split('/').last;
        imagesList
            .add(await MultipartFile.fromFile(image.path, filename: fileName));
      }
    }

    List<MultipartFile> files = [];
    for (var item in images) {
      if (item != null) {
        String fileName = item.path.split('/').last;
        files.add(await MultipartFile.fromFile(
          item.path,
          filename: fileName,
        ));
      }
    }
    FormData formData = FormData.fromMap({
      'car_id': carId,
      "category_id": catId,
      "address_name": adressName,
      "location_name": locationName,
      "lat": lat,
      "lng": lng,
      "order_place": orderPlace,
      "description": desc,
      "region_id": regionId,
      "city_id": cityId,
      "images[]": files,
    });

    var response = await dio.post(
      "${baseUrl}customer/orders",
      data: formData,
      options: Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: headers,
      ),
    );
    log(response.data.toString());
    return response.data['message'];
  }

  ////////////////////get orders list//////////////////////
  static Future<List<OrderModel>> getOrdersList({
    required String token,
    required String status,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}customer/orders?order_status=$status",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());

      if (response.statusCode == 200) {
        List<OrderModel> orders = [];
        orders = (response.data['data'] as List)
            .map((x) => OrderModel.fromJson(x))
            .toList();
        return orders;
      }
      return [];
    } on DioError catch (error) {
      log(error.message);
      return [];
    }
  }

  ////////////////////cancel order//////////////////////
  static Future cancelOrder({
    required String token,
    required String orderId,
    required String refusalId,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.post(
        "${baseUrl}customer/orders/$orderId/cancel",
        data: {
          "refusal_id": refusalId,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        OrderModel order = OrderModel.fromJson(response.data["data"]);

        return order;
      }
      if (response.statusCode == 400) {
        return response.data["message"];
      }
      return "error";
    } on DioError catch (error) {
      log(error.message);
      if (error.response!.statusCode == 400) {
        return error.response!.data["message"];
      }
      return "error";
    }
  }

  ////////////////////get orders list//////////////////////
  static Future<List<AnswerListModel>> getAnswers({
    required String token,
    required String id,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}customer/orders/$id/answers",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        List<AnswerListModel> answers = [];
        answers = (response.data['data'] as List)
            .map((x) => AnswerListModel.fromJson(x))
            .toList();
        return answers;
      }
      return [];
    } on DioError catch (error) {
      log(error.message);
      return [];
    }
  }

  ////////////////////accept order//////////////////////
  static Future acceptAnswer({
    required String token,
    required String orderId,
    required String answerId,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}customer/orders/$orderId/answers/$answerId/accept",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      return response.data["message"];
    } on DioError catch (error) {
      log(error.message);
      if (error.response!.statusCode == 400) {
        return error.response!.data["message"];
      }
      return error.response!.data["message"];
    }
  }

  ////////////////////rate provider//////////////////////
  static Future rateProvider({
    required String token,
    required String providerId,
    required int rate,
    required String message,
    required String orderId,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "provider_id": providerId,
        "rate": rate,
        "message": message,
        "order_id": orderId,
      });
      var response = await dio.post(
        "${baseUrl}customer/provider-rate",
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      return response.data["message"].toString();
    } on DioError catch (error) {
      log(error.message);
      return error.message;
    }
  }

  ////////////////////get orders//////////////////////
  static Future getOrder({
    required String token,
    required String id,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}customer/orders/$id",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());

      return OrderModel.fromJson(response.data["data"]);
    } on DioError catch (error) {
      log(error.message);
      return error.message;
    }
  }

  ////////////////////get invoice//////////////////////
  static Future getInvoice({
    required String token,
    required String id,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}customer/orders/$id/show-Invoice",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());

      return InvoiceModel.fromJson(response.data["data"]);
    } on DioError catch (error) {
      log(error.message);
      return error.message;
    }
  }

  ////////////////////get car info//////////////////////
  static Future getCarInfo({required String token, required String id}) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}customer/my-cars/$id",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      return CarModel.fromJson(response.data['data']);
    } on DioError catch (error) {
      log(error.message);
      return error.message;
    }
  }
}
