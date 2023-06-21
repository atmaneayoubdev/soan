// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/models/constumer/car_model.dart';
import 'package:soan/models/global/categories_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../controllers/costumer_controller.dart';
import '../../../../controllers/global_controller.dart';
import '../../../../helpers/user_provider.dart';
import '../../../../models/global/area_model.dart';
import '../../../../models/global/city_model.dart';
import '../../../Authentication/views/location_view.dart';
import '../../../Authentication/views/provider_first_register_view.dart';
import '../components/succesfull_sent_order_bottom_sheet.dart';

class CreateOrderView extends StatefulWidget {
  const CreateOrderView({Key? key, required this.categoryModel})
      : super(key: key);

  final CategoryModel categoryModel;

  @override
  State<CreateOrderView> createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  AreaModel? _selectedArea;
  CityModel? _selectedCity;
  List<AreaModel> areas = [];
  List<CityModel> cities = [];
  List<CarModel> _myCarsList = [];
  List<CategoryModel> _categories = [];
  LocModel? _locModel;

  // ignore: unused_field
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  CarModel? _selectedCar;
  CategoryModel? _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  bool isDelivery = true;
  bool isLoading = true;

  Future getMyCarsList() async {
    await CostumerController.getCostumerCars(
            Provider.of<UserProvider>(context, listen: false).user.apiToken,
            context.locale.languageCode)
        .then((value) {
      _myCarsList = value;
      setState(() {});
    });
  }

  Future getCategories() async {
    await GlobalController.getCategories(context.locale.languageCode)
        .then((value) {
      setState(() {
        _categories = value;
        _selectedCategory = _categories
            .firstWhere((element) => element.id == widget.categoryModel.id);
      });
    });
  }

  Future getAreas() async {
    await GlobalController.getAreaList(context.locale.languageCode)
        .then((value) {
      areas = value;
      if (value.isNotEmpty) {
        _selectedArea = value.first;
        getAreaCities(int.parse(value.first.id));
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  Future getAreaCities(int id) async {
    setState(() {
      _selectedCity = null;
    });
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getMyCarsList();
      getCategories();
      getAreas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: kLightLightSkyBlueColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 63.h,
                ),
                const BackButtonWidget(
                  color: kDarkBleuColor,
                ),
                SizedBox(
                  height: 18.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                            width: 200.w,
                            child: FittedBox(
                                child: Text(
                              "${LocaleKeys.costumer_home_fill_in_your_data.tr()}\n${LocaleKeys.costumer_home_service_request.tr()}",
                              style: GoogleFonts.tajawal(
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.bold),
                            ))),
                      ],
                    ),
                    Image.asset(
                      "assets/images/send_service_image.png",
                      height: 123.h,
                    ),
                  ],
                ),
                SizedBox(
                  height: 18.h,
                ),
                Expanded(
                  child: Container(
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.r),
                        topRight: Radius.circular(14.r),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            30.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: LocaleKeys.costumer_home_car.tr(),
                                    size: 14,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  13.verticalSpace,
                                  DropdownButtonFormField<CarModel>(
                                    borderRadius: BorderRadius.circular(16.r),
                                    //underline: const SizedBox(),
                                    decoration: formFieldDecoration,
                                    isExpanded: true,
                                    value: _selectedCar,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: _myCarsList.map((CarModel car) {
                                      return DropdownMenuItem(
                                        value: car,
                                        child: Text(
                                            "${car.manufacturer} ${car.vds}"),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return LocaleKeys
                                            .costumer_home_please_select_car
                                            .tr();
                                      }
                                      return null;
                                    },
                                    onChanged: (CarModel? newCar) {
                                      setState(() {
                                        _selectedCar = newCar!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: LocaleKeys
                                        .costumer_home_requied_type_of_service
                                        .tr(),
                                    size: 14,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  DropdownButtonFormField<CategoryModel>(
                                    borderRadius: BorderRadius.circular(16.r),
                                    //underline: const SizedBox(),
                                    decoration: formFieldDecoration,

                                    isExpanded: true,
                                    value: _selectedCategory,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: _categories.map((CategoryModel cat) {
                                      return DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat.name),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return LocaleKeys
                                            .costumer_home_please_select_class
                                            .tr();
                                      }
                                      return null;
                                    },
                                    onChanged: (CategoryModel? newCar) {
                                      setState(() {
                                        _selectedCategory = newCar!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: LocaleKeys.costumer_home_costumer_name
                                        .tr(),
                                    size: 14,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  TextFormField(
                                    controller: nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return LocaleKeys
                                            .costumer_home_please_enter_costumer_name
                                            .tr();
                                      }
                                      return null;
                                    },
                                    decoration: formFieldDecoration,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              child: Text(area.name),
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
                                    width: 5.w,
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
                                        SizedBox(
                                          width: 182.w,
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
                                                locationController.clear();
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
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: LocaleKeys.costumer_home_car_location
                                        .tr(),
                                    size: 14,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  TextFormField(
                                    showCursor: false,
                                    onTap: () {
                                      if (_selectedCity != null) {
                                        //Focus.of(context).unfocus();
                                        _handleLocationPermission()
                                            .then((value) {
                                          if (value == true) {
                                            Navigator.push<LocModel>(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LocationView(
                                                        selectedCity:
                                                            _selectedCity!
                                                                .name),
                                              ),
                                            ).then((value) {
                                              FocusManager
                                                  .instance.primaryFocus!
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
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            LocaleKeys.auth_select_city.tr(),
                                          ),
                                          backgroundColor: Colors.red,
                                        ));
                                      }
                                    },
                                    controller: locationController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return LocaleKeys
                                            .costumer_home_please_select_car_location
                                            .tr();
                                      }

                                      return null;
                                    },
                                    enabled: true,
                                    decoration: formFieldDecoration!.copyWith(
                                      suffixIcon: InkWell(
                                        onTap: () {},
                                        child: SizedBox(
                                          width: 40.w,
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (_selectedCity != null) {
                                                  //Focus.of(context).unfocus();
                                                  _handleLocationPermission()
                                                      .then((value) {
                                                    if (value == true) {
                                                      Navigator.push<LocModel>(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              LocationView(
                                                                  selectedCity:
                                                                      _selectedCity!
                                                                          .name),
                                                        ),
                                                      ).then((value) {
                                                        FocusManager.instance
                                                            .primaryFocus!
                                                            .unfocus();
                                                        if (value != null) {
                                                          _locModel = value;
                                                          locationController
                                                                  .text =
                                                              value.address;
                                                          setState(() {});
                                                        }
                                                      });
                                                    }
                                                  });
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      LocaleKeys
                                                          .auth_select_city
                                                          .tr(),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                'assets/icons/pick_location.svg',
                                                height: 40.h,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 17.h,
                                  ),
                                  // ,
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: LocaleKeys
                                            .costumer_home_problem_description
                                            .tr(),
                                        size: 14,
                                        color: kDarkBleuColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        //height: 126.h,
                                        child: TextFormField(
                                          controller: descriptionController,
                                          maxLines: null,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return LocaleKeys
                                                  .costumer_home_please_enter_problem_description
                                                  .tr();
                                            }
                                            return null;
                                          },
                                          decoration: formFieldDecoration,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        text: LocaleKeys
                                            .costumer_home_add_car_images
                                            .tr(),
                                        size: 14,
                                        color: kDarkBleuColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      TextWidget(
                                        text: LocaleKeys.costumer_home_optional
                                            .tr(),
                                        size: 14,
                                        color: kSkyBleuColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await _picker
                                                  .pickMultiImage(
                                                      imageQuality: 50)
                                                  .then((value) {
                                                if (value.isNotEmpty) {
                                                  List<File> temp = [];
                                                  for (XFile x in value) {
                                                    temp.add(File(x.path));
                                                  }
                                                  _images.addAll(temp);
                                                  setState(() {});
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: 96.h,
                                              width: 111.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                border: Border.all(
                                                  color: kSkyBleuColor,
                                                ),
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  "assets/icons/add_camera.svg",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      3.horizontalSpace,
                                      Expanded(
                                        //width: 111.w,
                                        child: SizedBox(
                                          height: 96.h,
                                          child: ListView.separated(
                                            itemCount: _images.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    height: 96.h,
                                                    width: 111.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                        color: kSkyBleuColor,
                                                      ),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      child: Image.file(
                                                        _images[index],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _images.removeAt(index);
                                                      setState(() {});
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black45,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.r),
                                                        ),
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                          size: 15.h,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return 3.horizontalSpace;
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 126.h,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(3, 0),
                                      color: kLightLightGreyColor,
                                      spreadRadius: 5,
                                      blurRadius: 2,
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  TextWidget(
                                    text: LocaleKeys
                                        .costumer_home_by_sending_providers_will_contact_you
                                        .tr(),
                                    size: 12,
                                    color: kSkyBleuColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  SizedBox(
                                    height: 13.h,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      for (var image in _images) {
                                        debugPrint(image.path);
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        isLoading = true;
                                        setState(() {});
                                        await CostumerController.createOrder(
                                          language: context.locale.languageCode,
                                          token: Provider.of<UserProvider>(
                                            context,
                                            listen: false,
                                          ).user.apiToken,
                                          carId: _selectedCar!.id,
                                          catId: _selectedCategory!.id,
                                          adressName: _locModel!.address,
                                          locationName: _locModel!.address,
                                          lat: _locModel!.latLng.latitude
                                              .toString(),
                                          lng: _locModel!.latLng.longitude
                                              .toString(),
                                          orderPlace: "in-location",
                                          desc: descriptionController.text,
                                          regionId: _selectedArea!.id,
                                          cityId: _selectedCity!.id,
                                          images: _images,
                                        ).then((value) {
                                          isLoading = false;
                                          setState(() {});

                                          if (value == "بيانات الطلب" ||
                                              value == 'Order Information') {
                                            modal
                                                .showMaterialModalBottomSheet(
                                              enableDrag: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) =>
                                                  const SuccesfullSentOrderBottomSheet(),
                                            )
                                                .then((value) {
                                              Navigator.of(context).pop();
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.red,
                                                duration:
                                                    const Duration(seconds: 3),
                                                content: Text(value.toString()),
                                              ),
                                            );
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 25.w,
                                      ),
                                      child: LargeButton(
                                        text:
                                            LocaleKeys.costumer_home_send.tr(),
                                        isButton: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
