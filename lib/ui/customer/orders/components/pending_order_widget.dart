import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soan/models/constumer/order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import 'cancle_widget.dart';
import '../view/order_details_view.dart';
import '../view/providers_services_view.dart';

class PendingOrderWidget extends StatelessWidget {
  const PendingOrderWidget({
    Key? key,
    required this.order,
    required this.onOrderUpdated,
  }) : super(key: key);
  final OrderModel order;
  final VoidCallback onOrderUpdated;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 351.w,
      //height: 280.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          //const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 72.h,
                    width: 72.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.r),
                      color: kLightLightGreyColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9.r),
                      child: CachedNetworkImage(
                        imageUrl: order.images.isNotEmpty
                            ? order.images.first.image
                            : "",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: SvgPicture.asset(
                            "assets/icons/car_logo_list.svg",
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: SvgPicture.asset(
                            "assets/icons/car_logo_list.svg",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      TextWidget(
                        text: "${order.car!.vds} ${order.car!.manufacturer}",
                        size: 14,
                        color: kDarkBleuColor,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        height: 17.h,
                        width: 55.w,
                        decoration: BoxDecoration(
                          color: kLightLightGreyColor,
                          borderRadius: BorderRadius.circular(
                            10.r,
                          ),
                        ),
                        child: TextWidget(
                          text: order.category.name,
                          size: 10,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: 260.w,
                        child: Text(
                          order.description,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.tajawal(
                            color: kGreyColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 9.h,
                            width: 9.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: order.answers.acceptCout != '0'
                                  ? kGreenColor
                                  : kPinkColor,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          context.locale.languageCode == 'en'
                              ? TextWidget(
                                  text: order.answers.acceptCout != '0'
                                      ? 'you have (${order.answers.acceptCout}) offers from providers'
                                      : 'waiting for providers offers',
                                  size: 12,
                                  color: order.answers.acceptCout != '0'
                                      ? kGreenColor
                                      : kPinkColor,
                                  fontWeight: FontWeight.normal,
                                )
                              : TextWidget(
                                  text: order.answers.acceptCout != '0'
                                      ? "لديك (${order.answers.acceptCout}) عروض من مزودي الخدمة"
                                      : "بانتظار عروض مزودي الخدمة",
                                  size: 12,
                                  color: order.answers.acceptCout != '0'
                                      ? kGreenColor
                                      : kPinkColor,
                                  fontWeight: FontWeight.normal,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      SizedBox(
                        width: 270.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (order.answers.acceptCout != "0")
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            ProvidersServicesView(
                                              orderId: order.id,
                                            )),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    height: 41.h,
                                    //width: 73.w,
                                    decoration: BoxDecoration(
                                      color: kLightLightGreenColor,
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    child: Center(
                                      child: FittedBox(
                                        child: TextWidget(
                                          text: LocaleKeys
                                              .titles_providers_offers
                                              .tr(),
                                          size: 12,
                                          color: kGreenColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => OrderDetailsView(
                                            order: order,
                                          )),
                                    ),
                                  ).then((value) {
                                    if (value == true) {
                                      onOrderUpdated();
                                    }
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  height: 41.h,
                                  //width: 73.w,
                                  decoration: BoxDecoration(
                                    color: kLightLightBlueColor,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  child: Center(
                                    child: FittedBox(
                                      child: TextWidget(
                                        text: LocaleKeys.titles_order_details
                                            .tr(),
                                        size: 12,
                                        color: kDarkBleuColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                modal
                                    .showMaterialModalBottomSheet(
                                  enableDrag: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => CancleWidget(
                                    order: order,
                                  ),
                                )
                                    .then((value) {
                                  if (value == true) {
                                    onOrderUpdated();
                                  }
                                });
                              },
                              child: Container(
                                height: 41.h,
                                //width: 73.w,
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                decoration: BoxDecoration(
                                  color: kLightLightPinkColor,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Center(
                                  child: TextWidget(
                                    text: LocaleKeys
                                        .costumer_my_orders_cancel_order
                                        .tr(),
                                    size: 12,
                                    color: kPinkColor,
                                    fontWeight: FontWeight.normal,
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
            ],
          ),
          //const Spacer(),
          const Divider(
            color: kLightGreyColor,
          ),
        ],
      ),
    );
  }
}
