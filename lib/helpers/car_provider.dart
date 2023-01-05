import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soan/models/constumer/car_model.dart';

class CarProvider with ChangeNotifier {
  CarModel? currentCar;

  Future<void> setCar(CarModel newCar) async {
    currentCar = newCar;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentCarId', newCar.id);
    notifyListeners();
  }

  Future<void> clearCar() async {
    currentCar = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentCarId', '');
    notifyListeners();
  }
}
