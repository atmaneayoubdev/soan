import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soan/models/provider/p_order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/customer/orders/components/sent_reply_bottom_sheet.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import '../../../customer/orders/components/send_reply_botton_sheet.dart';
import '../../orders/views/p_order_details.dart';

class PhomeListWidget extends StatefulWidget {
  const PhomeListWidget({
    Key? key,
    required this.order,
    required this.getorder,
  }) : super(key: key);
  final PorderModel order;
  final VoidCallback getorder;

  @override
  State<PhomeListWidget> createState() => _PhomeListWidgetState();
}

class _PhomeListWidgetState extends State<PhomeListWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.order.answer.answer != null) {
      controller.text = widget.order.answer.answer!.answer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 280.h,
      padding: EdgeInsets.all(20.h),
      //width: 385.w,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 5,
              spreadRadius: 5,
              color: kLightLightGreyColor,
            ),
          ]),
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
            text: widget.order.car != null
                ? "${widget.order.car!.vds} ${widget.order.car!.manufacturer}"
                : '',
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
                      text: widget.order.car != null
                          ? widget.order.car!.modelYear
                          : '',
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
                      text: widget.order.car != null
                          ? widget.order.car!.color.name
                          : '',
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
                      text:
                          widget.order.car != null ? widget.order.car!.vin : '',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        " ${LocaleKeys.provider_home_region.tr()}: "
                        "${widget.order.location.region.name}",
                        style: GoogleFonts.tajawal(
                          fontSize: 14.sp,
                          color: kLightDarkBleuColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    SizedBox(
                      width: 155.w,
                      height: 45.h,
                      child: GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                          },
                          child: GestureDetector(
                            onTap: () {
                              modal
                                  .showMaterialModalBottomSheet<bool>(
                                enableDrag: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) =>
                                    widget.order.answer.makeAnswer == 'true'
                                        ? SentReplyBottomSheet(
                                            message: widget
                                                .order.answer.answer!.answer,
                                          )
                                        : SendReplyBottomSheet(
                                            orderId: widget.order.id,
                                          ),
                              )
                                  .then((value) {
                                if (value == true) {
                                  widget.getorder();
                                }
                              });
                            },
                            child: widget.order.answer.makeAnswer == 'true'
                                ? Container(
                                    width: 155.w,
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10.r,
                                      ),
                                      color: kLightLightGreenColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/circle_green_check.svg',
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text(
                                          LocaleKeys.provider_home_reply_sent
                                              .tr(),
                                          style: GoogleFonts.tajawal(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.normal,
                                            color: kGreenColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : LargeButton(
                                    text: LocaleKeys.provider_home_send_reply
                                        .tr(),
                                    isButton: false),
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: " ${LocaleKeys.auth_city.tr()}: " "riyadh",
                      size: 14,
                      color: kLightDarkBleuColor,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PorderDetailsView(
                              isFromHome: true,
                              order: widget.order,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
