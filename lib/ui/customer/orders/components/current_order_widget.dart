import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:soan/models/constumer/order_model.dart';
import 'package:soan/models/global/categories_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Common/show_location.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import '../view/order_details_view.dart';
import 'reply_bottom_sheet_widget.dart';
import '../view/invoice_view.dart';

class CurrentOrderWidget extends StatefulWidget {
  const CurrentOrderWidget({
    Key? key,
    required this.order,
  }) : super(key: key);
  final OrderModel order;

  @override
  State<CurrentOrderWidget> createState() => _CurrentOrderWidgetState();
}

class _CurrentOrderWidgetState extends State<CurrentOrderWidget> {
  void _launchUrl(url) async {
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 351.w,
      height: 280.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  // const TextWidget(
                  //   text: "15 يوم",
                  //   size: 14,
                  //   color: kGreyColor,
                  //   fontWeight: FontWeight.normal,
                  // )
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
                        imageUrl: widget.order.provider!.avatar,
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
                        text: widget.order.provider!.providerName,
                        size: 14,
                        color: kDarkBleuColor,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 20.h,
                        width: 250.w,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.order.provider!.categories.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 5.w,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            CategoryModel cat =
                                widget.order.provider!.categories[index];
                            return Container(
                              height: 17.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: kLightLightGreyColor,
                                borderRadius: BorderRadius.circular(
                                  10.r,
                                ),
                              ),
                              child: TextWidget(
                                text: cat.name,
                                size: 10,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _launchUrl(
                                Uri.parse(
                                  "tel://${widget.order.provider!.phone}",
                                ),
                              );
                            },
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: kLightGreyColor,
                                ),
                                color: Colors.transparent,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/phone.svg',
                                    // ignore: deprecated_member_use
                                    color: kGreenColor,
                                  ),
                                  TextWidget(
                                    text: LocaleKeys.common_call.tr(),
                                    size: 12,
                                    color: kGreenColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 13.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => ShowLocationView(
                                          currentLocation: LatLng(
                                            double.parse(
                                                widget.order.location.lat),
                                            double.parse(
                                                widget.order.location.lng),
                                          ),
                                        )),
                                  ));
                            },
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: kLightGreyColor,
                                ),
                                color: Colors.transparent,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/marker.svg',
                                  ),
                                  TextWidget(
                                    text: LocaleKeys.common_location.tr(),
                                    size: 12,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 13.w,
                          ),
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
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: kLightGreyColor,
                                ),
                                color: Colors.transparent,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/invoice.svg',
                                  ),
                                  TextWidget(
                                    text: LocaleKeys.titles_invoice.tr(),
                                    size: 12,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 13.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              modal.showMaterialModalBottomSheet(
                                enableDrag: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) => ReplyBottomSheetWidget(
                                  response: widget.order.answers.accept!.answer,
                                ),
                              );
                            },
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: kLightGreyColor,
                                ),
                                color: Colors.transparent,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/center_reply.svg',
                                  ),
                                  TextWidget(
                                    text: LocaleKeys
                                        .costumer_my_orders_workshop_response
                                        .tr(),
                                    size: 12,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 9.h,
                            width: 9.w,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: kGreenColor),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          TextWidget(
                            text:
                                '${LocaleKeys.costumer_my_orders_contracted.tr()} ${widget.order.createdAt}',
                            size: 12,
                            color: kGreenColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => OrderDetailsView(
                                        order: widget.order,
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
                          ),
                        ],
                      ),
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
