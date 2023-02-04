import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/customer/landing_view.dart';
import 'package:soan/ui/customer/orders/components/succesfull_contract_bottom_sheet.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 72.h,
                width: 72.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.r),
                  color: kLightLightGreyColor,
                ),
                child: Center(
                  child: SvgPicture.asset("assets/icons/car_logo_list.svg"),
                ),
              ),
              10.horizontalSpace,
              SizedBox(
                width: 300.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: widget.answer.provider.providerName,
                          size: 14,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.normal,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                      ],
                    ),
                    10.verticalSpace,
                    SizedBox(
                      height: 20.h,
                      width: 300.w,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.answer.provider.categories.length,
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 5.w,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          CategoryModel cat =
                              widget.answer.provider.categories[index];
                          return Center(child: CatWidget(cat: cat));
                        },
                      ),
                    ),
                    10.verticalSpace,
                    Text(widget.answer.answer,
                        style: GoogleFonts.tajawal(
                          fontSize: 12.sp,
                          color: kLightDarkBleuColor,
                        )),
                    10.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/circle_phone.png',
                    height: 40.h,
                  ),
                  5.horizontalSpace,
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
                  10.horizontalSpace,
                  Container(
                    height: 17.h,
                    width: 1.w,
                    decoration: const BoxDecoration(
                      color: kLightGreyColor,
                    ),
                  ),
                  10.horizontalSpace,
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => ShowLocationView(
                                currentLocation: LatLng(
                                  double.parse(widget.answer.provider.lat),
                                  double.parse(widget.answer.provider.lng),
                                ),
                              )),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/circle_location.svg',
                          height: 40.h,
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
              40.horizontalSpace,
              GestureDetector(
                onTap: () {
                  modal
                      .showMaterialModalBottomSheet<bool>(
                    enableDrag: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) =>
                        AcceptContractWidget(answer: widget.answer),
                  )
                      .then((value) {
                    if (value != null) {
                      if (value) {
                        modal
                            .showMaterialModalBottomSheet<bool>(
                          enableDrag: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) =>
                              const SuccesfullContractBottomSheet(),
                        )
                            .then((value) {
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
                  height: 41.h,
                  width: 123.w,
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
          //const Spacer(),
          const Divider(
            color: kLightGreyColor,
          ),
        ],
      ),
    );
  }
}

class CatWidget extends StatelessWidget {
  const CatWidget({
    super.key,
    required this.cat,
  });

  final CategoryModel cat;

  @override
  Widget build(BuildContext context) {
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
  }
}
