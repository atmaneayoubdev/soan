import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:soan/Common/show_location.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/global/categories_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SoanProviderWidget extends StatelessWidget {
  const SoanProviderWidget({
    Key? key,
    required this.provider,
  }) : super(key: key);
  final ProviderModel provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 383.w,
        height: 150.h,
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: TextWidget(
                              text: provider.providerName,
                              size: 14,
                              color: kDarkBleuColor,
                              fontWeight: FontWeight.normal,
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
                                      "(${provider.ratesCount} ${LocaleKeys.common_ratings.tr()})",
                                  size: 12,
                                  color: kLightDarkBleuColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                TextWidget(
                                  text: provider.rates,
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
                      10.verticalSpace,
                      SizedBox(
                        height: 20.h,
                        child: ListView.separated(
                          itemCount: provider.categories.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 5.w,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            CategoryModel cat = provider.categories[index];
                            return Container(
                              height: 17.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: kLightLightGreyColor,
                                borderRadius: BorderRadius.circular(
                                  10.r,
                                ),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: "(${cat.name})",
                                  size: 10,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await launchUrl(
                                  Uri.parse(
                                    "tel://${provider.phone}",
                                  ),
                                );
                              },
                              child: Container(
                                height: 41.h,
                                width: 143.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(
                                    width: 1.w,
                                    color: kGreenColor,
                                  ),
                                  color: Colors.transparent,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/circle_phone.png',
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      TextWidget(
                                        text: LocaleKeys.common_call.tr(),
                                        size: 14,
                                        color: kGreenColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          20.horizontalSpace,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => ShowLocationView(
                                            currentLocation: LatLng(
                                              double.parse(provider.lat),
                                              double.parse(provider.lng),
                                            ),
                                          )),
                                    ));
                              },
                              child: Container(
                                height: 41.h,
                                width: 143.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: kLightLightBlueColor,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/circle_location.svg',
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
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
