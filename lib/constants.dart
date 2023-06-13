import 'package:flutter/material.dart';

const String baseUrl = "https://cpanel-soan.com/api/";
//const String baseUrl = "http://soun.tufahatin-sa.com/api/";

const Color kBlueColor = Color.fromRGBO(15, 76, 129, 1);
const Color kLightBlueColor = Color.fromRGBO(15, 76, 129, 0.5);
const Color kLightLightBlueColor = Color.fromRGBO(15, 76, 129, 0.1);

const Color kSkyBleuColor = Color.fromRGBO(159, 183, 205, 1);
const Color kLightSkyBleuColor = Color.fromRGBO(159, 183, 205, 0.5);
const Color kLightLightSkyBlueColor = Color.fromRGBO(15, 76, 129, 0.1);

const Color kOrangeColor = Color.fromRGBO(232, 161, 136, 1);
const Color kLightOrangeColor = Color.fromRGBO(232, 161, 136, 0.5);

const Color kDarkBleuColor = Color.fromRGBO(8, 39, 66, 1);
const Color kLightDarkBleuColor = Color.fromRGBO(8, 39, 66, 0.5);

const Color kGreyColor = Color.fromRGBO(159, 183, 205, 1);
const Color kLightGreyColor = Color.fromRGBO(159, 183, 205, 0.5);
const Color kLightLightGreyColor = Color.fromRGBO(159, 183, 205, 0.1);

const Color kGreenColor = Color.fromRGBO(182, 193, 118, 1);
const Color kLightGreenColor = Color.fromRGBO(182, 193, 118, 0.5);
const Color kLightLightGreenColor = Color.fromRGBO(182, 193, 118, 0.1);

const Color kPinkColor = Color.fromRGBO(243, 110, 142, 1);
const Color kLightPinkColor = Color.fromRGBO(243, 110, 142, 0.5);
const Color kLightLightPinkColor = Color.fromRGBO(243, 110, 142, 0.1);

const Color kCreemColor = Color.fromRGBO(248, 239, 225, 1);
const Color kLightCreemColor = Color.fromRGBO(248, 239, 225, 0.5);

InputDecoration? formFieldDecoration = const InputDecoration(
  errorMaxLines: 3,
  counterText: "",
  filled: true,
  fillColor: kLightLightGreyColor,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(
      width: 1,
      color: Colors.transparent,
    ),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(
      width: 1,
      color: Colors.transparent,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(
      width: 1,
      color: Colors.transparent,
    ),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(
      width: 1,
    ),
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        width: 1,
        color: Colors.red,
      )),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(
      width: 1,
      color: Colors.red,
    ),
  ),
);

//String googleMapApiKey = 'AIzaSyDAzLPkHKe18dOKCiDwPMubwQNehhuawaw';
