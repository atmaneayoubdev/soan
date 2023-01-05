import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/auth/user_model.dart';
import '../constants.dart';

class AuthController with ChangeNotifier {
////////////////////////////User Register///////////////////////////
  static Future userRegister({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String password,
    required String passwordConfirm,
    required String deviceToken,
    required int howToKnowUs,
  }) async {
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}customer/register",
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phoneNumber,
          'password': password,
          "password_confirmation": passwordConfirm,
          "devices_token": deviceToken,
          "how_to_know_us": 1,
        },
        options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {
              "Accept": "application/json",
            }),
      );
      log(response.toString());
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        return response.data['otp'].toString();
      }
      if (response.statusCode == 400) {
        return response.data['message'].toString();
      }
    } on DioError catch (error) {
      log(error.message.toString());
      log(error.response!.data.toString());
      if (error.response!.statusCode == 400) {
        return error.response!.data['message'].toString();
      }
      return "error";
    }
  }

////////////////////////////User Register///////////////////////////
  static Future providerRigester({
    required String companyName,
    required String phone,
    required String email,
    required String password,
    required String comercialRegistrationNbr,
    required String taxNbr,
    required double lat,
    required double lng,
    required int regionId,
    required int cityId,
    required howToKnowUs,
    required List<int> categories,
    required List<int> factories,
    required String deviceToken,
  }) async {
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}provider/register",
        data: {
          "provider_name": companyName,
          "phone": phone,
          "email": email,
          "password": password,
          "password_confirmation": password,
          "devices_token": deviceToken,
          "commercial_registration_number": comercialRegistrationNbr,
          "tax_number": taxNbr,
          "region": regionId,
          "city": cityId,
          "lat": lat,
          "lng": lng,
          "how_to_know_us": howToKnowUs,
          "categories": categories,
          "carCountryFactories": factories,
        },
        options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {
              "Accept": "application/json",
            }),
      );
      log(response.toString());
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        return response.data['otp'].toString();
      }
      if (response.statusCode == 400) {
        return response.data['message'].toString();
      }
    } on DioError catch (error) {
      log(error.message.toString());
      log(error.response!.data.toString());
      if (error.response!.statusCode == 400) {
        return error.response!.data['message'].toString();
      }
      return "error";
    }
  }

  ////////////////////////////Check OTP User////////////////////////////////
  static Future checkOtp({
    required String phone,
    required String otp,
  }) async {
    log("this is check phone $phone");
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}check-code-otp",
        // options: Options(
        //   followRedirects: false,
        //   validateStatus: (status) => true,
        // ),
        data: {
          'phone': phone,
          'otp': otp,
        },
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        UserModel user;
        user = UserModel.fromJson(response.data["data"]);
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        prefs.setString('firstName', user.firstName);
        prefs.setString('lastName', user.lastName);
        prefs.setString('phone', user.phoneNumber);
        prefs.setString('api_token', response.data['api_token']);
        prefs.setString('avatar', user.avatar);
        prefs.setString('email', user.email);
        prefs.setString('type', '1');
        user.apiToken = response.data['api_token'];
        return user;
      }
      if (response.statusCode == 400) {
        return response.data['message'];
      }
    } on DioError catch (error) {
      log(error.response!.data.toString());
      log(error.message.toString());
      if (error.response!.statusCode == 400) {
        return error.response!.data['message'];
      }
      return "error";
    }
  }

  ////////////////////////////Check OTP Provider////////////////////////////////
  static Future checkOtpProvider({
    required String phone,
    required String otp,
  }) async {
    log("this is check phone $phone");
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}check-code-otp",
        // options: Options(
        //   followRedirects: false,
        //   validateStatus: (status) => true,
        // ),
        data: {
          'phone': phone,
          'otp': otp,
        },
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
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
        prefs.setString('approved', provider.approved);
        prefs.setString('type', '2');
        prefs.setString('api_token', response.data['api_token']);

        provider.apiToken = response.data['api_token'];
        return provider;
      }
      if (response.statusCode == 400) {
        return response.data['message'];
      }
    } on DioError catch (error) {
      log(error.response!.data.toString());
      log(error.message.toString());
      if (error.response!.statusCode == 400) {
        return error.response!.data['message'];
      }
      return "error";
    }
  }

////////////////////////////ReSend OTP////////////////////////////////
  static Future reSendOtp(String phone) async {
    log("this is check phone $phone");
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}re-send",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
        ),
        data: {
          'phone': int.parse(phone),
        },
      );
      log(response.data.toString());

      if (response.statusCode == 200) {
        return response.data['otp'].toString();
      }
      if (response.statusCode == 400) {
        return response.data['message'].toString();
      }
    } on DioError catch (error) {
      log(error.message.toString());
      if (error.response!.statusCode == 400) {
        return error.response!.data['message'].toString();
      }
      return "error";
    }
  }

////////////////////////////login///////////////////////////
  static Future login({
    required String phoneNumber,
    required String password,
  }) async {
    log(password);
    log(phoneNumber);
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}login",
        data: {
          'phone': phoneNumber,
          'password': password,
          "devices_token": "123456789",
        },
      );
      log(response.data["data"].toString());

      log(response.data.toString());
      if (response.statusCode == 200 &&
          response.data["data"].containsKey("first_name")) {
        log('this is a user');
        log(response.data['api_token']);
        UserModel user;
        user = UserModel.fromJson(response.data["data"]);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('firstName', user.firstName);
        prefs.setString('lastName', user.lastName);
        prefs.setString('phone', user.phoneNumber);
        prefs.setString('api_token', response.data['api_token']);
        prefs.setString('avatar', user.avatar);
        prefs.setString('email', user.email);
        prefs.setString('type', '1');
        user.apiToken = response.data['api_token'];
        return user;
      }
      if (response.statusCode == 200 &&
          response.data["data"].containsKey('provider_name')) {
        log('this is a provider');
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
        prefs.setString('approved', provider.approved);
        prefs.setString('type', '2');
        prefs.setString('api_token', response.data['api_token']);
        provider.apiToken = response.data['api_token'];
        return provider;
      }
      if (response.statusCode == 400) {
        return response.data['message'];
      }
    } on DioError catch (error) {
      log(error.message.toString());
      log(error.message.toString());
      if (error.response!.statusCode == 400) {
        return error.response!.data['message'];
      }
      return "error";
    }
  }

  ////////////////////////////LogOut///////////////////////////
  static Future logout({
    required String token,
  }) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}logout",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        return response.data['message'];
      }
    } on DioError catch (error) {
      log(error.response!.statusCode.toString());
      log(error.message);
      return error.message.toString();
    }
  }

  ////////////////////////////Forgot Password///////////////////////////
  static Future<String> forgotPassword(String phone) async {
    try {
      Dio dio = Dio();
      var response = await dio.post("${baseUrl}forget-password",
          data: {
            'phone': phone,
          },
          options: Options(
            headers: {"Accept": "application/json"},
            followRedirects: false,
            validateStatus: (status) => true,
          ));
      log(response.data.toString());
      if (response.statusCode == 400) {
        return response.data["message"];
      }
      return response.data['otp'].toString();
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        return e.response!.data["message"];
      }
      return "error";
    }
  }

  ////////////////////////////Reset Password///////////////////////////
  static Future<String> resetPassword({
    required String phone,
    required String password,
    required double otp,
  }) async {
    try {
      Dio dio = Dio();
      var response = await dio.post(
        "${baseUrl}reset-password",
        data: {
          "phone": phone,
          "password": password,
          "otp": otp,
        },
      );
      log(response.data["message"].toString());
      return response.data["message"].toString();
    } on DioError catch (e) {
      log(e.response!.data.toString());
      log(e.response!.statusCode.toString());
      return e.response!.data["message"].toString();
    }
  }

  //////////////////////////////delete account//////////////////////

  static Future deleteAccount({
    required String token,
    required String type,
  }) async {
    try {
      Dio dio = Dio();
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': "Bearer $token",
      };

      var response = await dio.delete(
        "$baseUrl$type/my-profile/delete-account",
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      log(response.data.toString());
      return response.data['message'];
    } on DioError catch (error) {
      log(error.message);
      return error.response!.data['message'];
    }
  }
}
