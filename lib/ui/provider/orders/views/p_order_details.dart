import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soan/models/provider/p_order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/provider/orders/views/modify_invoice_view.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import '../../../customer/orders/components/send_reply_botton_sheet.dart';
import '../../../customer/orders/components/sent_reply_bottom_sheet.dart';
import '../components/payment_sent_bottom_sheet.dart';
import 'make_invoice_view.dart';

class PorderDetailsView extends StatefulWidget {
  const PorderDetailsView({
    Key? key,
    required this.order,
    required this.isFromHome,
  }) : super(key: key);
  final bool isFromHome;

  final PorderModel order;

  @override
  State<PorderDetailsView> createState() => _PorderDetailsViewState();
}

class _PorderDetailsViewState extends State<PorderDetailsView> {
  @override
  void initState() {
    super.initState();
    log(widget.order.orderStatus);
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
                  text: LocaleKeys.titles_order_details.tr(),
                  size: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(19.r),
                  topRight: Radius.circular(19.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    TextWidget(
                      text: LocaleKeys.costumer_my_orders_car_details.tr(),
                      size: 16,
                      color: kDarkBleuColor,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(
                      height: 11.h,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9.r),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 3),
                              spreadRadius: 5,
                              blurRadius: 5,
                              color: kLightLightGreyColor,
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 90.h,
                                width: 90.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: kLightLightGreyColor,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              SizedBox(
                                height: 80.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidget(
                                      text: widget.order.car!.vds,
                                      size: 18,
                                      color: kDarkBleuColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    TextWidget(
                                      text: widget.order.car!.vin,
                                      size: 12,
                                      color: kLightDarkBleuColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    Row(
                                      children: [
                                        TextWidget(
                                          text: widget.order.car!.manufacturer,
                                          size: 12,
                                          color: kLightDarkBleuColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        const TextWidget(
                                          text: "    -    ",
                                          size: 12,
                                          color: kLightDarkBleuColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        TextWidget(
                                          text: widget.order.car!.modelYear,
                                          size: 12,
                                          color: kLightDarkBleuColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextWidget(
                      text: LocaleKeys.costumer_my_orders_car_addresse.tr(),
                      size: 16,
                      color: kDarkBleuColor,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(
                      height: 11.h,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9.r),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 3),
                              spreadRadius: 5,
                              blurRadius: 5,
                              color: kLightLightGreyColor,
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 90.h,
                            width: 90.w,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: kLightLightGreyColor,
                            ),
                            child: Center(
                                child: Image.asset(
                              "assets/icons/direction.png",
                            )),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 60.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(
                                    text: widget.order.location.locationName,
                                    size: 18,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  TextWidget(
                                    text: widget.order.location.addressName,
                                    size: 12,
                                    color: kLightDarkBleuColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextWidget(
                      text: LocaleKeys.costumer_home_problem_description.tr(),
                      size: 16,
                      color: kDarkBleuColor,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(
                      height: 11.h,
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      height: 111.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: kLightLightGreyColor,
                      ),
                      child: TextWidget(
                        text: widget.order.description,
                        size: 12,
                        color: kLightDarkBleuColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextWidget(
                      text: LocaleKeys.costumer_my_orders_car_delivery.tr(),
                      size: 16,
                      color: kDarkBleuColor,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(
                      height: 11.h,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 23.h,
                          width: 23.w,
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kBlueColor,
                          ),
                          child: const FittedBox(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        TextWidget(
                          text: LocaleKeys
                              .costumer_my_orders_workshop_will_get_the_car
                              .tr(),
                          size: 16,
                          color: kLightDarkBleuColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    if (widget.order.images.isNotEmpty)
                      Column(
                        children: [
                          TextWidget(
                            text: LocaleKeys.costumer_home_add_car_images.tr(),
                            size: 16,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.normal,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          SizedBox(
                            height: 100.h,
                            width: double.infinity,
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.order.images.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: 10.w,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 100.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.r)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.r),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.order.images[index].image,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(
                                          color: kLightLightSkyBlueColor,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: CircularProgressIndicator(
                                          color: kLightLightSkyBlueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 20.h,
                    ),
                    if (!widget.isFromHome)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: LocaleKeys.provider_home_sent_reply.tr(),
                            size: 16,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.normal,
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            height: 111.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: kLightLightGreyColor,
                            ),
                            child: TextWidget(
                              text: widget.order.answer.answer!.answer,
                              size: 14,
                              color: kLightDarkBleuColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 15.h,
                    ),
                    /////////////////////////////////////
                    ////////////////////////////////////////
                    ////////////////////////////////////////
                    if (widget.isFromHome)
                      Column(
                        children: [
                          if (widget.order.answer.makeAnswer == "false")
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                modal.showMaterialModalBottomSheet(
                                  enableDrag: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => SendReplyBottomSheet(
                                      orderId: widget.order.id.toString()),
                                );
                              },
                              child: LargeButton(
                                  text:
                                      LocaleKeys.provider_home_send_reply.tr(),
                                  isButton: false),
                            ),
                          if (widget.order.answer.makeAnswer == "true")
                            GestureDetector(
                              onTap: () {
                                modal.showMaterialModalBottomSheet(
                                  enableDrag: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => SentReplyBottomSheet(
                                    message: widget.order.answer.answer!.answer,
                                  ),
                                );
                              },
                              child: LargeButton(
                                  text: LocaleKeys.provider_home_show_sent_reply
                                      .tr(),
                                  isButton: false),
                            ),
                        ],
                      ),

                    if (!widget.isFromHome &&
                        widget.order.orderStatus == 'process')
                      Column(
                        children: [
                          if (widget.order.invoiceItems.isNotEmpty)
                            SizedBox(
                              height: 10.h,
                            ),
                          if (widget.order.invoiceItems.isEmpty)
                            GestureDetector(
                              onTap: () {
                                Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MakeInvoiceView(
                                      order: widget.order,
                                    ),
                                  ),
                                );
                              },
                              child: LargeButton(
                                text: LocaleKeys.titles_create_invoice.tr(),
                                isButton: false,
                              ),
                            ),
                        ],
                      ),

                    if (!widget.isFromHome &&
                        widget.order.orderStatus == 'wait_for_pay')
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ModifyInvoiceView(
                                    order: widget.order,
                                  ),
                                ),
                              );
                            },
                            child: LargeButton(
                              text: LocaleKeys
                                  .provider_home_show_modify_inovoice
                                  .tr(),
                              isButton: false,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              modal.showMaterialModalBottomSheet<bool>(
                                enableDrag: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) =>
                                    PayementRecievedBottomSheet(
                                  order: widget.order,
                                ),
                              );
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10.r,
                                ),
                                color: kLightLightGreenColor,
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.provider_home_payement_received
                                      .tr(),
                                  style: GoogleFonts.tajawal(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.normal,
                                    color: kGreenColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    if (!widget.isFromHome &&
                        (widget.order.orderStatus == 'done' ||
                            widget.order.orderStatus == "cancel"))
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ModifyInvoiceView(
                                        order: widget.order,
                                      )));
                        },
                        child: LargeButton(
                          text: LocaleKeys.provider_home_show_invoice.tr(),
                          isButton: false,
                        ),
                      ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
