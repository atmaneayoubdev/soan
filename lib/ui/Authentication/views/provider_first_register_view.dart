// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:location/location.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/global_controller.dart';
import 'package:soan/models/global/area_model.dart';
import 'package:soan/models/global/city_model.dart';
import 'package:soan/models/global/how_to_know_us_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/Common/how_to_know_us_widget.dart';
import 'package:soan/ui/Authentication/views/provider_second_register_view.dart';
import '../../../Common/back_button.dart';
import '../../../Common/large_button.dart';
import '../../../Common/text_widget.dart';
import '../../../constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'location_view.dart';
import 'signin_view.dart';

class ProviderFirstRegisterView extends StatefulWidget {
  const ProviderFirstRegisterView({
    Key? key,
  }) : super(key: key);
  static const String routeName = "/signup_provider";

  @override
  State<ProviderFirstRegisterView> createState() =>
      _ProviderFirstRegisterViewState();
}

class _ProviderFirstRegisterViewState extends State<ProviderFirstRegisterView> {
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController registerNbrController = TextEditingController();
  TextEditingController taxNbrController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String finalPhone = '';
  bool agreeOnTermsAndConditions = false;
  bool isLoading = true;
  bool isHowError = false;
  List<AreaModel> areas = [];
  List<CityModel> cities = [];
  List<HowToKnowUsModel> howToKnowUsList = [];
  HowToKnowUsModel? _selectedHowToKnowUsModel;
  AreaModel? _selectedArea;
  CityModel? _selectedCity;
  LocModel? _locModel;

  Future getAreas() async {
    await GlobalController.getAreaList(context.locale.languageCode)
        .then((value) {
      areas = value;
      if (value.isNotEmpty) {
        _selectedArea = value.first;
        getAreaCities(int.parse(value.first.id));
      }
    });
  }

  Future getAreaCities(int id) async {
    await GlobalController.getAreaCities(id, context.locale.languageCode)
        .then((value) {
      setState(() {
        cities = value;
      });
      if (value.isNotEmpty) {
        _selectedCity = value.first;
      }
    });
  }

  Future getHowToKnowUsList() async {
    await GlobalController.getHowToKnowUsList(context.locale.languageCode)
        .then((value) {
      howToKnowUsList = value;
      if (value.isNotEmpty) {
        _selectedHowToKnowUsModel = howToKnowUsList.first;
      }
      setState(() {});
    });
  }

  Future<bool> _handleLocationPermission() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(LocaleKeys
                .costumer_providers_permission_denied_activate_location
                .tr()),
          ),
        );
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted != PermissionStatus.granted) {
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content:
                  Text(LocaleKeys.costumer_providers_permission_denied.tr()),
            ),
          );
          return false;
        }
      }

      if (permissionGranted == PermissionStatus.deniedForever) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(LocaleKeys
                  .costumer_providers_we_can_not_request_permission
                  .tr()),
            ),
          );
          return false;
        }
      }
    }

    return true;
  }

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getHowToKnowUsList();
      getAreas().then((value) {
        getAreaCities(int.parse(_selectedArea!.id));
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 418.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  "assets/images/singin_background.png",
                ),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 65.h,
                ),
                const BackButtonWidget(),
                SizedBox(
                  height: 125.h,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(80.r)),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 31.h,
                          ),
                          TextWidget(
                            text: LocaleKeys.titles_create_account.tr(),
                            size: 26,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextWidget(
                                text:
                                    "  ${LocaleKeys.auth_enter_company_name.tr()}  ",
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              TextFormField(
                                controller: companyNameController,
                                maxLines: 1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LocaleKeys.auth_enter_company_name
                                        .tr();
                                  }
                                  return null;
                                },
                                decoration: formFieldDecoration,
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              TextWidget(
                                text:
                                    "  ${LocaleKeys.auth_registration_number.tr()}  ",
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              TextFormField(
                                controller: registerNbrController,
                                maxLines: 1,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length != 10) {
                                    return LocaleKeys.auth_valid_reg_number
                                        .tr();
                                  }

                                  return null;
                                },
                                decoration: formFieldDecoration,
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
                                children: [
                                  TextWidget(
                                    text:
                                        " ${LocaleKeys.auth_tax_number.tr()} ",
                                    size: 16,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  5.horizontalSpace,
                                  TextWidget(
                                    text:
                                        LocaleKeys.costumer_home_optional.tr(),
                                    size: 16,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              TextFormField(
                                controller: taxNbrController,
                                maxLines: 1,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isNotEmpty && value.length != 15) {
                                    return LocaleKeys.auth_enter_tax_number
                                        .tr();
                                  }

                                  return null;
                                },
                                decoration: formFieldDecoration,
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text:
                                              "  ${LocaleKeys.auth_admin_region.tr()}  ",
                                          size: 16,
                                          color: kDarkBleuColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        DropdownButtonFormField<AreaModel>(
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                          decoration: formFieldDecoration,
                                          isExpanded: true,
                                          value: _selectedArea,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: areas.map((AreaModel area) {
                                            return DropdownMenuItem(
                                              value: area,
                                              child: FittedBox(
                                                  child: Text(area.name)),
                                            );
                                          }).toList(),
                                          validator: (value) {
                                            if (value == null) {
                                              return LocaleKeys
                                                  .auth_enter_region
                                                  .tr();
                                            }
                                            return null;
                                          },
                                          onChanged: (AreaModel? newArea) {
                                            setState(() {
                                              _selectedArea = newArea!;
                                            });
                                            getAreaCities(
                                                int.parse(_selectedArea!.id));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text:
                                              " ${LocaleKeys.auth_city.tr()} ",
                                          size: 16,
                                          color: kDarkBleuColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        Container(
                                          width: 182.w,
                                          decoration: const BoxDecoration(
                                              // borderRadius:
                                              //     BorderRadius.circular(5.r),
                                              // color: kLightLightGreyColor,
                                              ),
                                          child: DropdownButtonFormField<
                                              CityModel>(
                                            decoration: formFieldDecoration,
                                            borderRadius:
                                                BorderRadius.circular(16.r),
                                            isExpanded: true,
                                            value: _selectedCity,
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            items: cities.map((CityModel city) {
                                              return DropdownMenuItem(
                                                value: city,
                                                child: Text(city.name),
                                              );
                                            }).toList(),
                                            validator: (value) {
                                              if (value == null) {
                                                return LocaleKeys
                                                    .auth_select_city
                                                    .tr();
                                              }
                                              return null;
                                            },
                                            onChanged: (CityModel? newCity) {
                                              setState(() {
                                                _selectedCity = newCity!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              TextWidget(
                                text:
                                    "  ${LocaleKeys.auth_workshop_location.tr()}  ",
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              TextFormField(
                                onTap: () {
                                  //Focus.of(context).unfocus();
                                  _handleLocationPermission().then((value) {
                                    if (value == true) {
                                      Navigator.push<LocModel>(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LocationView(
                                                  selectedCity:
                                                      _selectedCity!.name,
                                                )),
                                      ).then((value) {
                                        FocusManager.instance.primaryFocus!
                                            .unfocus();
                                        if (value != null) {
                                          _locModel = value;
                                          locationController.text =
                                              value.address;
                                          setState(() {});
                                        }
                                      });
                                    }
                                  });
                                },
                                controller: locationController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LocaleKeys
                                        .auth_select_workshop_location
                                        .tr();
                                  }

                                  return null;
                                },
                                enabled: true,
                                decoration: formFieldDecoration!.copyWith(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      _handleLocationPermission().then((value) {
                                        if (value == true) {
                                          Navigator.push<LocModel>(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LocationView(
                                                      selectedCity:
                                                          _selectedCity!.name,
                                                    )),
                                          ).then((value) {
                                            FocusManager.instance.primaryFocus!
                                                .unfocus();
                                            if (value != null) {
                                              _locModel = value;
                                              locationController.text =
                                                  value.address;
                                              setState(() {});
                                            }
                                          });
                                        }
                                      });
                                    },
                                    child: SizedBox(
                                      width: 40.w,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/icons/pick_location.svg',
                                          height: 40.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              TextWidget(
                                text:
                                    "  ${LocaleKeys.auth_phone_number.tr()}  ",
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: IntlPhoneField(
                                  decoration: formFieldDecoration!,
                                  initialCountryCode: 'SA',
                                  keyboardType: TextInputType.phone,
                                  showDropdownIcon: true,
                                  disableLengthCheck: true,
                                  dropdownIcon: const Icon(
                                    Icons.abc,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (value) {
                                    var temp = value.countryCode + value.number;
                                    finalPhone = temp.replaceFirst("+", "");
                                  },
                                  onCountryChanged: (value) {
                                    finalPhone = '';

                                    phoneController.clear();
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    String pattern = r'[0-9]';
                                    RegExp regExp = RegExp(pattern);

                                    if (value == null ||
                                        value.number.isEmpty ||
                                        !regExp.hasMatch(value.number)) {
                                      return LocaleKeys
                                          .auth_enter_valid_phone_number
                                          .tr();
                                    }
                                    if (value.number.length != 9) {
                                      return LocaleKeys.auth_phone_must_be_9
                                          .tr();
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              TextWidget(
                                text:
                                    "  ${LocaleKeys.auth_how_you_know_us.tr()}  ",
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              SizedBox(
                                height: 70.h,
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: howToKnowUsList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    HowToKnowUsModel howToKnowUsModel =
                                        howToKnowUsList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isHowError = false;
                                          _selectedHowToKnowUsModel =
                                              howToKnowUsModel;
                                        });
                                      },
                                      child: HowToKnowUsWidgt(
                                        isError: isHowError,
                                        name: howToKnowUsModel.name,
                                        isActive: _selectedHowToKnowUsModel ==
                                                howToKnowUsModel
                                            ? true
                                            : false,
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      width: 20.w,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 44.h,
                              ),
                              SizedBox(
                                height: 22.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        agreeOnTermsAndConditions =
                                            !agreeOnTermsAndConditions;
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 22.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            border: Border.all(
                                              color: kBlueColor,
                                            )),
                                        child: agreeOnTermsAndConditions
                                            ? const FittedBox(
                                                child: Icon(Icons.check),
                                              )
                                            : const SizedBox.expand(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible:
                                              true, // user must tap button!
                                          builder: (BuildContext ctx) {
                                            return AlertDialog(
                                              contentPadding: EdgeInsets.zero,
                                              content: SizedBox(
                                                height: 800.h,
                                                width: 350.w,
                                                child: InAppWebView(
                                                  key: webViewKey,
                                                  initialUrlRequest: URLRequest(
                                                      url: Uri.parse(
                                                    "https://cpanel-soan.com/privacy-policy",
                                                  )),
                                                  initialOptions: options,
                                                  onWebViewCreated:
                                                      (controller) {
                                                    webViewController =
                                                        controller;
                                                  },
                                                  androidOnPermissionRequest:
                                                      (controller, origin,
                                                          resources) async {
                                                    return PermissionRequestResponse(
                                                        resources: resources,
                                                        action:
                                                            PermissionRequestResponseAction
                                                                .GRANT);
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          TextWidget(
                                            text: LocaleKeys
                                                .auth_agree_terms_and_conditions
                                                .tr(),
                                            size: 14,
                                            color: kDarkBleuColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          SizedBox(
                                            width: 10.h,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: kGreenColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const FittedBox(
                                                child: Icon(
                                              Icons.question_mark_sharp,
                                              color: Colors.white,
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate() &&
                                      agreeOnTermsAndConditions) {
                                    if (_selectedHowToKnowUsModel != null) {
                                    } else {
                                      setState(() {
                                        isHowError = true;
                                      });
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            ProviderSecondRegisterView(
                                              companyName: companyNameController
                                                  .text
                                                  .trim(),
                                              registrationNbr:
                                                  registerNbrController.text
                                                      .trim(),
                                              taxNbr:
                                                  taxNbrController.text.trim(),
                                              areaId:
                                                  int.parse(_selectedArea!.id),
                                              cityId:
                                                  int.parse(_selectedCity!.id),
                                              lat: _locModel!.latLng.latitude,
                                              lng: _locModel!.latLng.longitude,
                                              phone: finalPhone,
                                              howToKnowUs: int.parse(
                                                _selectedHowToKnowUsModel!.id,
                                              ),
                                            )),
                                      ),
                                    );
                                  }
                                },
                                child: LargeButton(
                                    text: LocaleKeys.auth_create.tr(),
                                    isButton: false),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Center(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            SignInView.routeName,
                                            (Route<dynamic> route) => false);
                                  },
                                  child: Container(
                                    height: 51.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kBlueColor),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          ' ${LocaleKeys.auth_have_an_account.tr()} ',
                                          style: GoogleFonts.tajawal(
                                            color: kDarkBleuColor,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        Text(
                                          LocaleKeys.titles_singin.tr(),
                                          style: GoogleFonts.tajawal(
                                              color: kGreenColor,
                                              fontSize: 16.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) const LoadingWidget(),
        ],
      ),
    );
  }
}

class LocModel {
  String address;
  LatLng latLng;

  LocModel({
    required this.address,
    required this.latLng,
  });
}
