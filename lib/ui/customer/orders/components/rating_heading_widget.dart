import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingHeaderWidget extends StatelessWidget {
  const RatingHeaderWidget({
    Key? key,
    required this.provdier,
  }) : super(key: key);
  final ProviderModel provdier;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 385.w,
      //height: 250.h,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 3),
              spreadRadius: 5,
              blurRadius: 2,
              color: kLightLightGreyColor,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/home_add_image.png',
              height: 82.h,
              width: 140.w,
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          TextWidget(
            text: provdier.providerName,
            size: 14,
            color: kDarkBleuColor,
            fontWeight: FontWeight.normal,
          ),
          SizedBox(
            height: 10.h,
          ),
          if (provdier.categories.isNotEmpty)
            SizedBox(
              height: 20.h,
              width: 200.w,
              child: Center(
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: provdier.categories.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 5.w,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
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
                        text: provdier.categories[index].name,
                        size: 10,
                        color: kDarkBleuColor,
                        fontWeight: FontWeight.normal,
                      ),
                    );
                  },
                ),
              ),
            ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 10.h,
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: double.parse(provdier.rates).toInt(),
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 0.w,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return const Center(
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          TextWidget(
            text: "(${provdier.ratesCount} ${LocaleKeys.common_ratings.tr()})",
            size: 11,
            color: kDarkBleuColor,
            fontWeight: FontWeight.normal,
          )
        ],
      ),
    );
  }
}
