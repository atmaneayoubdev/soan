import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/costumer_controller.dart';
import 'package:soan/helpers/car_provider.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/constumer/car_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../views/add_car_view.dart';

class AddCarButtonSheet extends StatefulWidget {
  const AddCarButtonSheet({Key? key}) : super(key: key);

  @override
  State<AddCarButtonSheet> createState() => _AddCarButtonSheetState();
}

class _AddCarButtonSheetState extends State<AddCarButtonSheet> {
  CarModel? _selectedCar;
  List<CarModel> _carsList = [];
  bool isEmpty = false;
  bool isLoading = false;

  Future getMyCarsList() async {
    isLoading = true;
    setState(() {});
    await CostumerController.getCostumerCars(
            Provider.of<UserProvider>(context, listen: false).user.apiToken,
            context.locale.languageCode)
        .then((value) {
      _carsList = value;
      value.isEmpty ? isEmpty = true : isEmpty = false;
      isLoading = false;
      setState(() {});
    });
  }

  Future deleteCar(int id) async {
    await CostumerController.deleteCar(
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      id: id,
      language: context.locale.languageCode,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getMyCarsList().then((value) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(19.r),
          topRight: Radius.circular(19.r),
        ),
      ),
      child: !isEmpty
          ? Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 5.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: kGreyColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(19.r),
                          topRight: Radius.circular(19.r),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      height: 260.h,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        shrinkWrap: true,
                        itemCount: _carsList.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 11.h,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          CarModel car = _carsList[index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text(
                                          " ${car.manufacturer}"
                                          " "
                                          "${car.vds} ",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.tajawal(
                                              fontSize: 21.sp,
                                              color: kDarkBleuColor,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await CostumerController.deleteCar(
                                              language:
                                                  context.locale.languageCode,
                                              token: Provider.of<UserProvider>(
                                                      context,
                                                      listen: false)
                                                  .user
                                                  .apiToken,
                                              id: int.parse(car.id),
                                            ).then((value) {
                                              if (value == "تم مسح السياره") {
                                                getMyCarsList();
                                                if (_selectedCar == car) {
                                                  _selectedCar = null;
                                                }
                                                if (Provider.of<CarProvider>(
                                                      context,
                                                      listen: false,
                                                    ).currentCar!.vin ==
                                                    car.vin) {
                                                  Provider.of<CarProvider>(
                                                    context,
                                                    listen: false,
                                                  ).clearCar();
                                                }
                                              }
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            'assets/icons/add_bin.svg',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30.w,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (_selectedCar == car) {
                                              _selectedCar = null;
                                              setState(() {});
                                            } else {
                                              _selectedCar = car;
                                              setState(() {});
                                            }
                                          },
                                          child: Icon(
                                            Icons.check_circle_rounded,
                                            color: _selectedCar == car
                                                ? kBlueColor
                                                : kLightLightBlueColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _selectedCar != null
                            ? GestureDetector(
                                onTap: () {
                                  Provider.of<CarProvider>(context,
                                          listen: false)
                                      .setCar(_selectedCar!);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 175.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      10.r,
                                    ),
                                    color: kBlueColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.auth_save.tr(),
                                      style: GoogleFonts.tajawal(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const AddCarView()),
                                    ),
                                  ).then((value) => getMyCarsList());
                                },
                                child: Container(
                                  width: 175.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      10.r,
                                    ),
                                    color: kBlueColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.titles_add_car.tr(),
                                      style: GoogleFonts.tajawal(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 175.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.r,
                              ),
                              color: kLightLightBlueColor,
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.common_cancel.tr(),
                                style: GoogleFonts.tajawal(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: kDarkBleuColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isLoading) const LoadingWidget(),
              ],
            )
          : Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 5.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: kGreyColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(19.r),
                          topRight: Radius.circular(19.r),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/home_add_image.png',
                        height: 150.h,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    const TextWidget(
                      text: "لا توجد سيارات محفوظة",
                      size: 21,
                      color: kDarkBleuColor,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const AddCarView()))).then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            width: 175.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.r,
                              ),
                              color: kBlueColor,
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.titles_add_car.tr(),
                                style: GoogleFonts.tajawal(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 175.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.r,
                              ),
                              color: kLightLightBlueColor,
                            ),
                            child: Center(
                              child: Text(
                                LocaleKeys.common_cancel.tr(),
                                style: GoogleFonts.tajawal(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: kDarkBleuColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isLoading) const LoadingWidget(),
              ],
            ),
    );
  }
}
