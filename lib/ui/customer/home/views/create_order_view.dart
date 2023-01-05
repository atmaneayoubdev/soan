import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/models/constumer/car_model.dart';
import 'package:soan/models/global/categories_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/customer/landing_view.dart';
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
  File? _image1;
  File? _image2;
  File? _image3;
  CarModel? _selectedCar;
  CategoryModel? _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  bool isDelivery = true;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  Future getMyCarsList() async {
    await CostumerController.getCostumerCars(
            Provider.of<UserProvider>(context, listen: false).user.apiToken)
        .then((value) {
      _myCarsList = value;
      setState(() {});
    });
  }

  Future getCategories() async {
    await GlobalController.getCategories().then((value) {
      setState(() {
        _categories = value;
        _selectedCategory = _categories
            .firstWhere((element) => element.id == widget.categoryModel.id);
      });
    });
  }

  Future getAreas() async {
    await GlobalController.getAreaList().then((value) {
      areas = value;
      if (value.isNotEmpty) {
        _selectedArea = value.first;
        getAreaCities(int.parse(value.first.id));
      }
    });
  }

  Future getAreaCities(int id) async {
    await GlobalController.getAreaCities(id).then((value) {
      setState(() {
        cities = value;
      });
      if (value.isNotEmpty) {
        _selectedCity = value.first;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getMyCarsList();
    getCategories();
    getAreas();
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
                        // FittedBox(
                        //   child: SizedBox(
                        //     width: 162.w,
                        //     child: TextWidget(
                        //       text:
                        //           LocaleKeys.costumer_home_service_request.tr(),
                        //       size: 22,
                        //       color: kDarkBleuColor,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // )
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
                    width: double.infinity,
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
                          children: [
                            SizedBox(
                              height: 31.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: LocaleKeys.costumer_home_car.tr(),
                                    size: 14,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
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
                                    onTap: () {
                                      //Focus.of(context).unfocus();
                                      Navigator.push<LocModel>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LocationView(),
                                        ),
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
                                                Navigator.push<LocModel>(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LocationView(),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await _picker
                                                  .pickImage(
                                                source: ImageSource.camera,
                                              )
                                                  .then((value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _image1 =
                                                        (File(value.path));
                                                  });
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
                                              child: _image1 != null
                                                  ? Image.file(
                                                      _image1!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Center(
                                                      child: SvgPicture.asset(
                                                        "assets/icons/add_camera.svg",
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          if (_image1 != null)
                                            GestureDetector(
                                              onTap: () {
                                                _image1 = null;
                                                setState(() {});
                                              },
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black45,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r),
                                                  ),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 15.h,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await _picker
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery)
                                                  .then((value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _image2 =
                                                        (File(value.path));
                                                  });
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
                                              child: _image2 != null
                                                  ? Image.file(
                                                      _image2!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Center(
                                                      child: SvgPicture.asset(
                                                        "assets/icons/add_camera.svg",
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          if (_image2 != null)
                                            GestureDetector(
                                              onTap: () {
                                                _image2 = null;
                                                setState(() {});
                                              },
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black45,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r),
                                                  ),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 15.h,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await _picker
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery)
                                                  .then((value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _image3 =
                                                        (File(value.path));
                                                  });
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
                                              child: _image3 != null
                                                  ? Image.file(
                                                      _image3!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Center(
                                                      child: SvgPicture.asset(
                                                        "assets/icons/add_camera.svg",
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          if (_image3 != null)
                                            GestureDetector(
                                              onTap: () {
                                                _image3 = null;
                                                setState(() {});
                                              },
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black45,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.r),
                                                  ),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 15.h,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ],
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
                                      if (_formKey.currentState!.validate()) {
                                        isLoading = true;
                                        setState(() {});
                                        await CostumerController.createOrder(
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
                                            images: [
                                              _image1,
                                              _image2,
                                              _image3
                                            ]).then((value) {
                                          isLoading = false;
                                          setState(() {});

                                          if (value == "بيانات الطلب") {
                                            showMaterialModalBottomSheet(
                                              enableDrag: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) => Container(
                                                height: 826.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(19.r),
                                                    topRight:
                                                        Radius.circular(19.r),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.h,
                                                    ),
                                                    Container(
                                                      height: 5.h,
                                                      width: 50.w,
                                                      decoration: BoxDecoration(
                                                        color: kGreyColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  19.r),
                                                          topRight:
                                                              Radius.circular(
                                                                  19.r),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 122.h,
                                                    ),
                                                    SizedBox(
                                                      width: 350.w,
                                                      child: Image.asset(
                                                          "assets/images/send_service_image_bottom.png"),
                                                    ),
                                                    SizedBox(
                                                      height: 80.h,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 25.w),
                                                      child: TextWidget(
                                                        text:
                                                            " ${LocaleKeys.costumer_home_orders_sent_sucessfully.tr()} ",
                                                        size: 22,
                                                        color: kDarkBleuColor,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 25.w),
                                                      child: TextWidget(
                                                        text: LocaleKeys
                                                            .costumer_home_be_ready_to_recieve
                                                            .tr(),
                                                        size: 22,
                                                        color: kDarkBleuColor,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 50.h,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LandingView(
                                                                    selectedIndex:
                                                                        2),
                                                          ),
                                                          (route) => false,
                                                        );
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 25.w,
                                                        ),
                                                        child: LargeButton(
                                                            text: LocaleKeys
                                                                .titles_my_orders
                                                                .tr(),
                                                            isButton: true),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.red,
                                                duration:
                                                    const Duration(seconds: 3),
                                                content: Text(
                                                  value,
                                                ),
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
