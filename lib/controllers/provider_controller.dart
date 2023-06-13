import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soan/constants.dart';
import 'package:soan/models/global/inoice_item_model.dart';
import 'package:soan/models/provider/dues_model.dart';
import 'package:soan/models/provider/p_order_model.dart';

import '../models/auth/provider_model.dart';
import '../models/constumer/notification_model.dart';
import '../models/global/invoice_model.dart';

class ProviderController with ChangeNotifier {
  ////////////////////////////change user info///////////////////////////
  static Future updateProfile({
    required String token,
    required String language,
    required String providerName,
    File? image,
  }) async {
    Dio dio = Dio();
    Map<String, String> headers = {
      'Content-type': 'multipart/from-data',
      "Accept": "application/json",
      'Authorization': "Bearer $token",
      'Accept-Language': language,
    };

    if (image != null) {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        'provider_name': providerName,
        "avatar": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      var response = await dio.post(
        "${baseUrl}provider/my-profile",
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      ProviderModel provider;
      provider = ProviderModel.fromJson(response.data['data']);
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      prefs.setString("id", provider.id);
      prefs.setString('provider_name', provider.providerName);
      prefs.setString('email', provider.email);
      prefs.setString('phone', provider.phone);
      prefs.setString('commercial_registration_number',
          provider.commercialRegistrationNumber);
      prefs.setString('tax_number', provider.taxNumber);
      prefs.setString('lat', provider.lat);
      prefs.setString('lng', provider.lng);
      prefs.setString('terms', provider.terms);
      prefs.setString('rates', provider.rates);
      prefs.setString('rates_count', provider.ratesCount);
      prefs.setString('avatar', provider.avatar);

      prefs.setString('type', '2');
      prefs.setString('api_token', token);

      provider.apiToken = token;
      return provider;
    } else {
      FormData formData = FormData.fromMap({
        'provider_name': providerName,
      });
      var response = await dio.post(
        "${baseUrl}provider/my-profile",
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      ProviderModel provider;
      provider = ProviderModel.fromJson(response.data['data']);
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      prefs.setString("id", provider.id);
      prefs.setString('provider_name', provider.providerName);
      prefs.setString('email', provider.email);
      prefs.setString('phone', provider.phone);
      prefs.setString('commercial_registration_number',
          provider.commercialRegistrationNumber);
      prefs.setString('tax_number', provider.taxNumber);
      prefs.setString('lat', provider.lat);
      prefs.setString('lng', provider.lng);
      prefs.setString('terms', provider.terms);
      prefs.setString('rates', provider.rates);
      prefs.setString('rates_count', provider.ratesCount);
      prefs.setString('avatar', provider.avatar);

      prefs.setString('type', '2');
      prefs.setString('api_token', token);

      provider.apiToken = token;
      return provider;
    }
  }

  ////////////////////Show profile//////////////////////
  static Future showProfile({
    required String token,
    required String language,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}provider/my-profile",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data['message']);
      ProviderModel provider;
      provider = ProviderModel.fromJson(response.data['data']);
      return provider;
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.message!;
    }
  }

  ////////////////////////////change user phone///////////////////////////
  static Future updatePhone({
    required String token,
    required String phone,
    required String password,
    required String language,
  }) async {
    try {
      Dio dio = Dio();
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };
      debugPrint(password);
      debugPrint(phone);
      var response = await dio.post(
        "${baseUrl}provider/my-profile/change-phone",
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
      debugPrint(response.data.toString());
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
      debugPrint(error.message!);
      return error.response!.data['message'];
    }
  }

  ////////////////////////////change user password///////////////////////////
  static Future updatePassword({
    required String token,
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
    required String language,
  }) async {
    try {
      Dio dio = Dio();
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };

      var response = await dio.post(
        "${baseUrl}provider/my-profile/change-password",
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
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        return response.data['message'] == 'Invalid data'
            ? response.data['errors'].first['value']
            : response.data['message'];
      }
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.response!.data['message'];
    }
  }

  ////////////////////get dues//////////////////////
  static Future getDuesOrders(
    String token,
    String language,
  ) async {
    try {
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}provider/dues",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        DuesModel dues = DuesModel.fromJson(response.data["data"]);
        return dues;
      } else {
        return "error";
      }
    } on DioError catch (error) {
      debugPrint(error.message!);
      return "error";
    }
  }

  ////////////////////////////change user password///////////////////////////
  static Future makeDues({
    required String token,
    required String language,
  }) async {
    try {
      Dio dio = Dio();
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };

      var response = await dio.post(
        "${baseUrl}provider/dues",
        options: Options(
          // followRedirects: false,
          // validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        return response.data["data"]["InvoiceURL"].toString();
      }
      return response.data['message'];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.response!.data['message'];
    }
  }

  ////////////////////get notifications//////////////////////
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
        "${baseUrl}provider/notifications",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200) {
        List<NotificationModel> notifications = [];
        notifications = (response.data['data'] as List)
            .map((x) => NotificationModel.fromJson(x))
            .toList();
        return notifications;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get orders list//////////////////////
  static Future<List<PorderModel>> getOrdersList({
    required String token,
    required String language,
    required String status,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}provider/orders?order_status=$status",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        List<PorderModel> orders = [];
        orders = (response.data['data'] as List)
            .map((x) => PorderModel.fromJson(x))
            .toList();
        return orders;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get orders list//////////////////////
  static Future<List<PorderModel>> getOrdersThatNeedsAnswer({
    required String token,
    required String language,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}provider/orders-need-answers",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      if (response.statusCode == 200) {
        List<PorderModel> orders = [];
        orders = (response.data['data'] as List)
            .map((x) => PorderModel.fromJson(x))
            .toList();
        return orders;
      }
      return [];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return [];
    }
  }

  ////////////////////get orders list//////////////////////
  static Future makeOrderAnswer({
    required String token,
    required String orderId,
    required String language,
    required String message,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.post(
        "${baseUrl}provider/orders/$orderId/make-answer",
        data: {
          'answer': message,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data['message']);
      return response.data['message'];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.message!;
    }
  }

  ////////////////////confirm take money//////////////////////
  static Future confirmTakeMoney({
    required String token,
    required String orderId,
    required String language,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}provider/orders/$orderId/confirm-take-money",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data['message']);
      return response.data['message'];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.message!;
    }
  }

  ////////////////////get orders list//////////////////////
  static Future addUpdateBill({
    required String token,
    required String orderId,
    required List<InvoiceItemModel> items,
    required double subTotal,
    required double vat,
    required double total,
    required String language,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };
      Dio dio = Dio();
      List jsonList = [];
      items.map((item) => jsonList.add(item.toJson())).toList();
      var response = await dio.post(
        "${baseUrl}provider/orders/$orderId/add-update-bill",
        data: {
          "sub_total": subTotal,
          "vat": vat,
          "total": total,
          "items": jsonList,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data['message']);
      return response.data['message'];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.message!;
    }
  }

  ////////////////////get orders list//////////////////////
  static Future updateTerms({
    required String token,
    required String terms,
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
        "${baseUrl}provider/my-profile/add-update-terms",
        data: {
          'terms': terms,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());
      return response.data['message'];
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.message!;
    }
  }

  ////////////////////get invoice//////////////////////
  static Future getInvoice({
    required String token,
    required String id,
    required String language,
  }) async {
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
        'Accept-Language': language,
      };
      Dio dio = Dio();

      var response = await dio.get(
        "${baseUrl}provider/orders/$id/show-Invoice",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      debugPrint(response.data.toString());

      return InvoiceModel.fromJson(response.data["data"]);
    } on DioError catch (error) {
      debugPrint(error.message!);
      return error.message!;
    }
  }
}
