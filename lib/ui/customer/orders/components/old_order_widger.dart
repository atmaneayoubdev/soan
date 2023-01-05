import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soan/models/constumer/order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../view/order_details_view.dart';
import 'types_widget.dart';

class OldOrderWidget extends StatelessWidget {
  const OldOrderWidget({
    Key? key,
    required this.order,
  }) : super(key: key);
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 351.w,
      height: 250.h,
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
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
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
                        imageUrl: order.provider != null
                            ? order.provider!.avatar
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
                        text: order.provider!.providerName,
                        size: 14,
                        color: kDarkBleuColor,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(
                        height: 11.h,
                      ),
                      SizedBox(
                        height: 17.h,
                        width: 250.w,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: order.provider!.categories.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 5.w,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return TypeWidget(
                              name: order.provider!.categories[index].name,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      TextWidget(
                        text:
                            "${LocaleKeys.costumer_my_orders_service_total_cost.tr()}  ${order.price.total} ${LocaleKeys.common_sar.tr()}  ",
                        size: 14,
                        color: kLightDarkBleuColor,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 250.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 9.h,
                                  width: 9.w,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kPinkColor),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                TextWidget(
                                  text:
                                      "${LocaleKeys.costumer_my_orders_order_finished.tr()} ${order.createdAt}",
                                  size: 12,
                                  color: kPinkColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text:
                                      "(${order.provider!.ratesCount} ${LocaleKeys.common_ratings.tr()}) ",
                                  size: 12,
                                  color: kGreyColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                TextWidget(
                                  text: order.provider!.rates,
                                  size: 12,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                SvgPicture.asset("assets/icons/star.svg"),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => OrderDetailsView(
                                    order: order,
                                  ))));
                        },
                        child: Container(
                          height: 51.h,
                          width: 260.w,
                          decoration: BoxDecoration(
                            color: kLightLightBlueColor,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                            child: TextWidget(
                              text: LocaleKeys.titles_order_details.tr(),
                              size: 16,
                              color: kDarkBleuColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
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
