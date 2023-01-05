import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:soan/controllers/global_controller.dart';
import 'package:soan/helpers/car_provider.dart';
import 'package:soan/models/constumer/car_model.dart';
import 'package:soan/models/global/color_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../controllers/costumer_controller.dart';
import '../../../../helpers/user_provider.dart';
import '../../../../models/global/car_country_factory_model.dart';

class AddCarView extends StatefulWidget {
  const AddCarView({Key? key, this.existingCar}) : super(key: key);
  final CarModel? existingCar;

  @override
  State<AddCarView> createState() => _AddCarViewState();
}

class _AddCarViewState extends State<AddCarView> {
  TextEditingController vinController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  CarCountryFactoryModel? _selectedFactory;
  List<CarCountryFactoryModel> _factories = [];

  final _formKey = GlobalKey<FormState>();
  List<ColorModel> colors = [];
  List<String> makers = [];
  List<String> models = [];
  ColorModel? _selectedColor;
  String? _selectedMaker;
  String? _selectedModel;
  bool isLoading = true;
  bool isTypeRed = false;
  bool isListCollaps = false;

  Future getColors() async {
    await GlobalController.getColors().then((value) {
      colors = value;
      setState(() {});
    });
  }

  Future getFactories() async {
    await GlobalController.getCarCountryFactories().then((value) {
      setState(() {
        _factories = value;
      });
    });
  }

  Future getMakers() async {
    await GlobalController.getMakers().then((value) {
      makers = value;
      setState(() {});
    });
  }

  Future getModels(String maker) async {
    await GlobalController.getModels(maker).then((value) {
      _selectedModel = null;
      models = value;
      setState(() {});
    });
  }

  void getExistingCarData() {
    if (widget.existingCar != null) {
      _selectedFactory = _factories.firstWhere(
          (element) => element.id == widget.existingCar!.carCountryFactory.id);
      _selectedColor = colors
          .firstWhere((element) => element.id == widget.existingCar!.color.id);
      _selectedMaker = widget.existingCar!.manufacturer.toString();
      vinController.text = widget.existingCar!.vin.toString();
      yearController.text = widget.existingCar!.modelYear.toString();
      getModels(_selectedMaker!).then((value) {
        _selectedModel = widget.existingCar!.vds.toString();
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getFactories();
    getMakers();
    getColors().then((value) {
      getExistingCarData();
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            height: 120.h,
            child: Stack(children: [
              Align(
                alignment: context.locale.languageCode == 'en'
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                child: const BackButtonWidget(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextWidget(
                  text: LocaleKeys.titles_add_car.tr(),
                  size: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(19.r),
                  topRight: Radius.circular(19.r),
                ),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    //vertical: 40.h,
                  ),
                  height: 738.h,
                  width: 385.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(19.r),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        color: kLightLightGreyColor,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text:
                                    " ${LocaleKeys.costumer_home_car_factory.tr()} ",
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              DropdownButtonFormField<CarCountryFactoryModel>(
                                borderRadius: BorderRadius.circular(16.r),
                                //underline: const SizedBox(),
                                decoration: formFieldDecoration,

                                isExpanded: true,
                                value: _selectedFactory,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: _factories
                                    .map((CarCountryFactoryModel factroy) {
                                  return DropdownMenuItem(
                                    value: factroy,
                                    child: Text(factroy.name),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return LocaleKeys
                                        .costumer_home_select_factory_please
                                        .tr();
                                  }
                                  return null;
                                },
                                onChanged:
                                    (CarCountryFactoryModel? newFactory) {
                                  setState(() {
                                    _selectedFactory = newFactory!;
                                  });
                                },
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 16.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text:
                                          " ${LocaleKeys.costumer_home_car_manufacturer.tr()} ",
                                      size: 16,
                                      color: kDarkBleuColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    DropdownButtonFormField<String>(
                                      borderRadius: BorderRadius.circular(16.r),
                                      //underline: const SizedBox(),
                                      decoration: formFieldDecoration,

                                      isExpanded: true,
                                      value: _selectedMaker,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: makers.map((String maker) {
                                        return DropdownMenuItem(
                                          value: maker,
                                          child: Text(maker),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null) {
                                          return LocaleKeys
                                              .costumer_home_please_select_manufacturer
                                              .tr();
                                        }
                                        return null;
                                      },
                                      onChanged: (String? newMaker) {
                                        setState(() {
                                          _selectedMaker = newMaker!;
                                          getModels(newMaker);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text:
                                          " ${LocaleKeys.costumer_home_car_model.tr()} ",
                                      size: 16,
                                      color: kDarkBleuColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: formFieldDecoration,
                                      borderRadius: BorderRadius.circular(16.r),
                                      isExpanded: true,
                                      value: _selectedModel,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: models.map((String model) {
                                        return DropdownMenuItem(
                                          value: model,
                                          child: Text(model),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null) {
                                          return LocaleKeys
                                              .costumer_home_please_select_model
                                              .tr();
                                        }
                                        return null;
                                      },
                                      onChanged: (String? newModel) {
                                        setState(() {
                                          _selectedModel = newModel!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: LocaleKeys.costumer_home_color.tr(),
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              DropdownButtonFormField<ColorModel>(
                                borderRadius: BorderRadius.circular(16.r),
                                //underline: const SizedBox(),
                                decoration: formFieldDecoration,

                                isExpanded: true,
                                value: _selectedColor,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: colors.map((ColorModel color) {
                                  return DropdownMenuItem(
                                    value: color,
                                    child: Text(color.name),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return LocaleKeys
                                        .costumer_home_please_select_color
                                        .tr();
                                  }
                                  return null;
                                },
                                onChanged: (ColorModel? newColor) {
                                  setState(() {
                                    _selectedColor = newColor!;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: LocaleKeys.costumer_home_chassis_number
                                    .tr(),
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              TextFormField(
                                controller: vinController,
                                maxLines: 1,
                                maxLength: 17,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LocaleKeys
                                        .costumer_home_please_select_chassis_nbr
                                        .tr();
                                  }
                                  if (value.length != 17) {
                                    return LocaleKeys
                                        .costumer_home_chassis_must_be_17
                                        .tr();
                                  }
                                  return null;
                                },
                                decoration: formFieldDecoration,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: LocaleKeys.costumer_home_year.tr(),
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              TextFormField(
                                controller: yearController,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                maxLength: 4,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LocaleKeys
                                        .costumer_home_please_enter_year
                                        .tr();
                                  }

                                  if (value.length != 4) {
                                    return LocaleKeys
                                        .costumer_home_enter_valid_year_please
                                        .tr();
                                  }
                                  return null;
                                },
                                decoration: formFieldDecoration,
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 30.h,
                          ),
                          //const Spacer(),
                          isLoading
                              ? SizedBox(
                                  height: 100.h,
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    color: kBlueColor,
                                  )),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      isLoading = true;

                                      setState(() {});
                                      if (widget.existingCar != null) {
                                        await CostumerController.updateCar(
                                          token: Provider.of<UserProvider>(
                                            context,
                                            listen: false,
                                          ).user.apiToken,
                                          carFactoryId: _selectedFactory!.id,
                                          colorId: _selectedColor!.id,
                                          make: _selectedMaker!,
                                          models: _selectedModel!,
                                          year: yearController.text,
                                          vin: vinController.text,
                                          id: int.parse(widget.existingCar!.id),
                                        ).then((value) {
                                          isLoading = false;
                                          setState(() {});
                                          if (value.runtimeType == CarModel) {
                                            Provider.of<CarProvider>(context,
                                                    listen: false)
                                                .setCar(value);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration:
                                                    const Duration(seconds: 3),
                                                backgroundColor: kBlueColor,
                                                content: Text(
                                                  LocaleKeys
                                                      .costumer_home_car_created_succesfully
                                                      .tr(),
                                                ),
                                              ),
                                            );
                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration:
                                                    const Duration(seconds: 3),
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  value.toString(),
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                      } else {
                                        await CostumerController.addCar(
                                          token: Provider.of<UserProvider>(
                                            context,
                                            listen: false,
                                          ).user.apiToken,
                                          carFactoryId: _selectedFactory!.id,
                                          colorId: _selectedColor!.id,
                                          make: _selectedMaker!,
                                          models: _selectedModel!,
                                          year: yearController.text,
                                          vin: vinController.text,
                                        ).then((value) {
                                          isLoading = false;
                                          setState(() {});
                                          if (value.runtimeType == CarModel) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration:
                                                    const Duration(seconds: 3),
                                                backgroundColor: kBlueColor,
                                                content: Text(
                                                  LocaleKeys
                                                      .costumer_home_car_created_succesfully
                                                      .tr(),
                                                ),
                                              ),
                                            );
                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration:
                                                    const Duration(seconds: 3),
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                  value.toString(),
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                      }
                                    }
                                  },
                                  child: LargeButton(
                                    text: LocaleKeys.auth_save.tr(),
                                    isButton: false,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
