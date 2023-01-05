import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soan/models/provider/dues_order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BillWidget extends StatelessWidget {
  const BillWidget({
    Key? key,
    required this.order,
  }) : super(key: key);
  final DuesOrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      //height: 79.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: kLightLightSkyBlueColor,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            height: 62.h,
            width: 62.w,
            decoration: BoxDecoration(
                color: kLightLightGreyColor,
                borderRadius: BorderRadius.circular(10.r)),
            child: Center(
                child: SvgPicture.asset(
              "assets/icons/bill.svg",
            )),
          ),
          SizedBox(
            width: 18.w,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                    text: "${LocaleKeys.titles_invoice.tr()} #${order.id}",
                    size: 14,
                    color: kDarkBleuColor,
                    fontWeight: FontWeight.normal),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                        text: LocaleKeys.provider_settings_date.tr(),
                        size: 14,
                        color: kLightDarkBleuColor,
                        fontWeight: FontWeight.normal),
                    SizedBox(
                      width: 5.w,
                    ),
                    TextWidget(
                        text: order.createdAt,
                        size: 14,
                        color: kDarkBleuColor,
                        fontWeight: FontWeight.normal)
                  ],
                ),
              ],
            ),
          ),
          //const Spacer(),
          SizedBox(
            width: 10.w,
          ),
          TextWidget(
            text: "${order.dues} - ${LocaleKeys.common_sar.tr()}",
            size: 14,
            color: kPinkColor,
            fontWeight: FontWeight.normal,
          ),
        ],
      ),
    );
  }
}
