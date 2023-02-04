import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soan/models/provider/p_order_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../translations/locale_keys.g.dart';
import '../views/p_order_details.dart';

class PcurrentOrdersWidget extends StatefulWidget {
  const PcurrentOrdersWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  final PorderModel order;

  @override
  State<PcurrentOrdersWidget> createState() => _PcurrentOrdersWidgetState();
}

class _PcurrentOrdersWidgetState extends State<PcurrentOrdersWidget> {
  void _launchUrl(url) async {
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
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
                text: "#${widget.order.id}",
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
                    text: widget.order.createdAt,
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
            text: "${widget.order.car!.manufacturer} ${widget.order.car!.vds}",
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
                      text: widget.order.car!.modelYear,
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
                      text: widget.order.car!.color.name,
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
                      text: widget.order.car!.vin,
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
                Align(
                  alignment: context.locale.languageCode == 'en'
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 11.h,
                        width: 11.w,
                        decoration: BoxDecoration(
                          color: widget.order.invoiceItems.isNotEmpty
                              ? kDarkBleuColor
                              : kGreenColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      context.locale.languageCode == 'ar'
                          ? Text(
                              widget.order.invoiceItems.isNotEmpty
                                  ? "تم اصدار الفاتورة ${double.parse(widget.order.price.total).toStringAsFixed(0)} ريال ، بانتظار تاكيد استلام المبلغ"
                                  : "تم التعاقد  ${widget.order.processAt}",
                              //maxLines: 2,
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.tajawal(
                                  fontSize: 14.r,
                                  color: widget.order.invoiceItems.isNotEmpty
                                      ? kDarkBleuColor
                                      : kGreenColor,
                                  fontWeight: FontWeight.normal),
                            )
                          : Text(
                              widget.order.invoiceItems.isNotEmpty
                                  ? "${LocaleKeys.provider_orders_invoice_was_created.tr()} ${double.parse(widget.order.price.total).toStringAsFixed(0)} ${LocaleKeys.provider_orders_waiting_payement.tr()}"
                                  : "${LocaleKeys.costumer_my_orders_contracted.tr()} ${widget.order.processAt}",
                              // maxLines: 2,
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.tajawal(
                                  fontSize: 14.r,
                                  color: widget.order.invoiceItems.isNotEmpty
                                      ? kDarkBleuColor
                                      : kGreenColor,
                                  fontWeight: FontWeight.normal),
                            )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _launchUrl(
                          Uri.parse(
                            "tel://${widget.order.costumer.phoneNumber}",
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
                          color: kBlueColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/phone.svg",
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Center(
                              child: Text(
                                LocaleKeys.common_call.tr(),
                                style: GoogleFonts.tajawal(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PorderDetailsView(
                                isFromHome: false,
                                order: widget.order,
                              ),
                            ));
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
                            LocaleKeys.titles_order_details.tr(),
                            style: GoogleFonts.tajawal(
                              fontSize: 16.sp,
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
