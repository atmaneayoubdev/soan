import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/customer/landing_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Common/show_location.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../models/global/answer_list_model.dart';
import '../../../../models/global/categories_model.dart';
import 'accept_contract_widget.dart';

class AnswerWidget extends StatefulWidget {
  const AnswerWidget({
    Key? key,
    required this.answer,
  }) : super(key: key);

  final AnswerListModel answer;

  @override
  State<AnswerWidget> createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  void _launchUrl(url) async {
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 383.w,
        height: 190.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 73.h,
                  //width: 383.w,
                  child: Row(
                    children: [
                      Container(
                        height: 72.h,
                        width: 72.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.r),
                          color: kLightLightGreyColor,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                              "assets/icons/car_logo_list.svg"),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: widget.answer.provider.providerName,
                            size: 14,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.normal,
                          ),
                          SizedBox(
                            height: 20.h,
                            width: 190.w,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  widget.answer.provider.categories.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: 5.w,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                CategoryModel cat =
                                    widget.answer.provider.categories[index];
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
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text:
                            "(${widget.answer.provider.ratesCount} ${LocaleKeys.common_ratings.tr()})",
                        size: 12,
                        color: kLightDarkBleuColor,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      TextWidget(
                        text: widget.answer.provider.rates,
                        size: 12,
                        color: kDarkBleuColor,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      SvgPicture.asset("assets/icons/star.svg"),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: 300.w,
              height: 35.h,
              child: TextWidget(
                text: widget.answer.answer,
                size: 12,
                color: kLightDarkBleuColor,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 41.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 20.h,
                    //width: 143.w,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/circle_phone.png',
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchUrl(
                                Uri.parse(
                                  "tel://${widget.answer.provider.phone}",
                                ),
                              );
                            },
                            child: TextWidget(
                              text: LocaleKeys.common_call.tr(),
                              size: 14,
                              color: kGreenColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            height: 17.h,
                            width: 1.w,
                            decoration: const BoxDecoration(
                              color: kLightGreyColor,
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
                                    builder: ((context) => ShowLocationView(
                                          currentLocation: LatLng(
                                            double.parse(
                                                widget.answer.provider.lat),
                                            double.parse(
                                                widget.answer.provider.lng),
                                          ),
                                        )),
                                  ));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/circle_location.svg',
                                  height: 20.h,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                TextWidget(
                                  text: LocaleKeys.common_location.tr(),
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
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      showMaterialModalBottomSheet<bool>(
                        enableDrag: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) =>
                            AcceptContractWidget(answer: widget.answer),
                      ).then((value) {
                        if (value != null) {
                          if (value) {
                            showMaterialModalBottomSheet<bool>(
                              enableDrag: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => Container(
                                height: 450.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(19.r),
                                    topRight: Radius.circular(19.r),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Center(
                                      child: Container(
                                        height: 5.h,
                                        width: 50.w,
                                        decoration: BoxDecoration(
                                            color: kGreyColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(19.r),
                                                topRight:
                                                    Radius.circular(19.r))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    Image.asset(
                                      "assets/images/succesfull_contract.png",
                                      height: 190.h,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    TextWidget(
                                      text: LocaleKeys
                                          .costumer_home_contract_succesfull
                                          .tr(),
                                      size: 24,
                                      color: kDarkBleuColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    TextWidget(
                                      text: LocaleKeys
                                          .costumer_home_thanks_for_your_trust
                                          .tr(),
                                      size: 24,
                                      color: kLightDarkBleuColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    TextWidget(
                                      text: LocaleKeys
                                          .costumer_home_you_can_track_order_status
                                          .tr(),
                                      size: 24,
                                      color: kLightDarkBleuColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ],
                                ),
                              ),
                            ).then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => const LandingView(
                                            selectedIndex: 2,
                                          ))),
                                  (route) => false);
                            });
                          }
                        }
                      });
                    },
                    child: Container(
                      height: 41.w,
                      width: 123.h,
                      decoration: BoxDecoration(
                        color: kLightLightBlueColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: TextWidget(
                          text: LocaleKeys.costumer_home_contract.tr(),
                          size: 12,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.normal,
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
      ),
    );
  }
}
