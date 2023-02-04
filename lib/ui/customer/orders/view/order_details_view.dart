import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import 'package:soan/models/constumer/order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/customer/orders/components/cancle_widget.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'invoice_view.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({Key? key, required this.order}) : super(key: key);
  final OrderModel order;

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: CachedNetworkImage(
                                  imageUrl: widget.order.costumer.avatar,
                                  fit: BoxFit.cover,
                                ),
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
                                    text: widget.order.category.name,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    height: 111.h,
                    width: double.infinity,
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
                          text: LocaleKeys.costumer_my_orders_car_images.tr(),
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
                                    imageUrl: widget.order.images[index].image,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
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
                  if (widget.order.provider == null)
                    GestureDetector(
                      onTap: () {
                        modal
                            .showMaterialModalBottomSheet<bool>(
                          enableDrag: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) =>
                              CancleWidget(order: widget.order),
                        )
                            .then((value) {
                          if (value == true) {
                            Navigator.pop(context, value);
                          }
                        });
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: 53.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10.r,
                          ),
                          color: kLightLightPinkColor,
                        ),
                        child: Center(
                          child: Text(
                            LocaleKeys.costumer_my_orders_cancel_order.tr(),
                            style: GoogleFonts.tajawal(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                              color: kPinkColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (widget.order.orderStatus == 'done')
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => InvoiceView(
                                  orderId: widget.order.id,
                                )),
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
                          child: LargeButton(
                            text: LocaleKeys.provider_home_show_invoice.tr(),
                            isButton: false,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
