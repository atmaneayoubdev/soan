import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:soan/helpers/car_provider.dart';
import 'package:soan/models/constumer/car_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/large_grey_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import 'package:flutter_svg/flutter_svg.dart';
import '../views/add_car_view.dart';
import 'add_car_bottom_sheet.dart';

class HomeAddWidget extends StatefulWidget {
  const HomeAddWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeAddWidget> createState() => _HomeAddWidgetState();
}

class _HomeAddWidgetState extends State<HomeAddWidget> {
  CarModel? _selectedCar;
  @override
  Widget build(BuildContext context) {
    _selectedCar = Provider.of<CarProvider>(context, listen: true).currentCar;
    return Container(
      width: 385.w,
      height: 330.h,
      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
      padding: EdgeInsets.symmetric(
        horizontal: 13.w,
        vertical: 13.h,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 3),
              spreadRadius: 5,
              blurRadius: 5,
              color: kLightLightGreyColor,
            )
          ]),
      child: _selectedCar == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      modal.showMaterialModalBottomSheet<CarModel>(
                        enableDrag: false,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => const AddCarButtonSheet(),
                      );
                    },
                    child: Image.asset('assets/icons/home_add_icon.png')),
                SizedBox(
                  height: 16.h,
                ),
                Center(
                    child: Image.asset(
                  'assets/images/home_add_image.png',
                  height: 100.h,
                )),
                const Spacer(),
                Center(
                  child: TextWidget(
                    text: LocaleKeys.costumer_home_add_car_details.tr(),
                    size: 14,
                    color: kLightDarkBleuColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const AddCarView())),
                    );
                  },
                  child: LargeButton(
                    text: LocaleKeys.titles_add_car.tr(),
                    isButton: false,
                  ),
                ),
              ],
            )
          :
          ////////////////////////////////////////
          ///////////////////////////////////////
          //////////////////////////////////////
          Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      modal.showMaterialModalBottomSheet<CarModel>(
                        enableDrag: false,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => const AddCarButtonSheet(),
                      );
                    },
                    child: Image.asset('assets/icons/home_add_icon.png'),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/home_add_image.png',
                        height: 82.h,
                        width: 140.w,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: SvgPicture.asset(
                          "assets/icons/add_car_separator.svg"),
                    ),
                    const Spacer(),
                    Center(
                      child: TextWidget(
                        text:
                            "${_selectedCar!.vds} . ${_selectedCar!.manufacturer}",
                        size: 23,
                        color: kDarkBleuColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 71.h,
                            width: 69.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: Colors.white,
                              border: Border.all(
                                width: 2.h,
                                color: kLightLightGreyColor,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/steering_wheel.svg",
                                ),
                                TextWidget(
                                  text: _selectedCar!.modelYear,
                                  size: 14,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 17.w,
                          ),
                          Container(
                            height: 71.h,
                            width: 69.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: Colors.white,
                              border: Border.all(
                                width: 2.h,
                                color: kLightLightGreyColor,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset("assets/icons/add_car.svg"),
                                TextWidget(
                                  text: _selectedCar!.color.name,
                                  size: 14,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 17.w,
                          ),
                          Container(
                            height: 71.h,
                            width: 69.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: Colors.white,
                              border: Border.all(
                                width: 2.h,
                                color: kLightLightGreyColor,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset("assets/icons/milage.svg"),
                                TextWidget(
                                  text: _selectedCar!.vin,
                                  size: 14,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 45.h,
                            width: 155.w,
                            child: GestureDetector(
                                onTap: () {
                                  modal.showMaterialModalBottomSheet(
                                    enableDrag: false,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) =>
                                        const AddCarButtonSheet(),
                                  );
                                },
                                child: LargeButton(
                                  text: LocaleKeys.costumer_home_add_other.tr(),
                                  isButton: false,
                                ))),
                        SizedBox(
                          width: 20.w,
                        ),
                        SizedBox(
                          height: 45.h,
                          width: 155.w,
                          child: Container(
                            width: double.maxFinite,
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.r,
                              ),
                              color: kLightLightBlueColor,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => AddCarView(
                                              existingCar: _selectedCar,
                                            ))));
                              },
                              child: LargeGreyButton(
                                text: LocaleKeys.costumer_home_modify.tr(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
