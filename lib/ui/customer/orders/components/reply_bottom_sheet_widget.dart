import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReplyBottomSheetWidget extends StatelessWidget {
  const ReplyBottomSheetWidget({
    Key? key,
    required this.response,
  }) : super(key: key);
  final String response;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 381.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(19.r),
          topRight: Radius.circular(19.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  topRight: Radius.circular(19.r),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25.w),
            child: TextWidget(
              text: LocaleKeys.costumer_my_orders_provider_response.tr(),
              size: 14,
              color: kDarkBleuColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Center(
            child: Container(
              alignment: Alignment.topRight,
              height: 162.h,
              width: 377.w,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kLightLightGreyColor,
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: TextWidget(
                text: response,
                size: 18,
                color: kDarkBleuColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
