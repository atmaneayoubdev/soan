import 'package:flutter/material.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/global/city_model.dart';
import 'package:soan/models/global/how_to_know_us_model.dart';
import 'package:soan/models/global/region_model.dart';

class ProviderProvider with ChangeNotifier {
  ProviderModel providerModel = ProviderModel(
    id: '',
    providerName: '',
    phone: '',
    commercialRegistrationNumber: '',
    taxNumber: '',
    lat: '',
    lng: '',
    terms: '',
    rates: '',
    ratesCount: '',
    apiToken: 'apiToken',
    avatar: '',
    email: '',
    carCountryFactories: [],
    categories: [],
    city: CityModel(name: '', id: ''),
    howToKnowUs: HowToKnowUsModel(name: '', id: ''),
    region: RegionModel(name: '', id: ''),
    approved: '',
  );

  void setProvider(ProviderModel newProvider) {
    providerModel = newProvider;
    notifyListeners();
  }

  void clearUser() {
    providerModel = ProviderModel(
      id: '',
      providerName: '',
      phone: '',
      commercialRegistrationNumber: '',
      taxNumber: '',
      lat: '',
      lng: '',
      terms: '',
      rates: '',
      ratesCount: '',
      apiToken: 'apiToken',
      avatar: '',
      email: '',
      carCountryFactories: [],
      categories: [],
      city: CityModel(name: '', id: ''),
      howToKnowUs: HowToKnowUsModel(name: '', id: ''),
      region: RegionModel(name: '', id: ''),
      approved: '',
    );
    notifyListeners();
  }
}
