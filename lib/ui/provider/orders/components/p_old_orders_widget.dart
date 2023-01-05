import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soan/models/provider/p_order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../views/p_order_details.dart';

class PoldOrdersWidget extends StatelessWidget {
  const PoldOrdersWidget({
    Key? key,
    required this.order,
  }) : super(key: key);
  final PorderModel order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      //padding: EdgeInsets.all(10.h),
      //width: 385.w,
      //margin: EdgeInsets.symmetric(horizontal: 20.w),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: "#${order.id}",
                size: 14,
                color: kLightDarkBleuColor,
                fontWeight: FontWeight.normal,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset("assets/icons/clock.svg"),
                  SizedBox(
                    width: 10.w,
                  ),
                  TextWidget(
                    text: order.createdAt,
                    size: 14,
                    color: kLightDarkBleuColor,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          TextWidget(
            text: "${order.car!.manufacturer} ${order.car!.vds}",
            size: 23,
            color: kDarkBleuColor,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 17.h,
          ),
          Row(
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
                    SvgPicture.asset("assets/icons/steering_wheel.svg"),
                    TextWidget(
                      text: order.car!.modelYear,
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
                      text: order.car!.color.name,
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
                      text: order.car!.vin,
                      size: 14,
                      color: kDarkBleuColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 17.h,
          ),
          SizedBox(
            width: 325.w,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 11.h,
                          width: 11.w,
                          decoration: const BoxDecoration(
                            color: kPinkColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        FittedBox(
                          child: Text(
                            "${LocaleKeys.costumer_my_orders_order_finished.tr()} ${order.completedAt}  ",
                            style: GoogleFonts.tajawal(
                                fontSize: 14.r,
                                color: kPinkColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    FittedBox(
                      child: Text(
                        "${LocaleKeys.costumer_my_orders_service_total_cost.tr()} ${order.price.total} ${LocaleKeys.common_sar.tr()} ",
                        style: GoogleFonts.tajawal(
                          fontSize: 14.r,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: 325.w,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PorderDetailsView(
                            order: order,
                            isFromHome: false,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 155.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10.r,
                        ),
                        color: kLightLightBlueColor,
                      ),
                      child: Center(
                        child: Text(
                          "تفاصيل الطلب",
                          style: GoogleFonts.tajawal(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal,
                            color: kDarkBleuColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Divider(
            color: kLightGreyColor,
          ),
        ],
      ),
    );
  }
}
