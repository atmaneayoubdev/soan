import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../landing_view.dart';

class SuccesfullSentOrderBottomSheet extends StatelessWidget {
  const SuccesfullSentOrderBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 826.h,
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
          Container(
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
          SizedBox(
            height: 122.h,
          ),
          SizedBox(
            width: 350.w,
            child: Image.asset("assets/images/send_service_image_bottom.png"),
          ),
          SizedBox(
            height: 80.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: TextWidget(
              text:
                  " ${LocaleKeys.costumer_home_orders_sent_sucessfully.tr()} ",
              size: 22,
              color: kDarkBleuColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: TextWidget(
              text: LocaleKeys.costumer_home_be_ready_to_recieve.tr(),
              size: 22,
              color: kDarkBleuColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: TextWidget(
              text: LocaleKeys.costumer_home_in_ordes_screen.tr(),
              size: 22,
              color: kDarkBleuColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LandingView(selectedIndex: 2),
                ),
                (route) => false,
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 25.w,
              ),
              child: LargeButton(
                  text: LocaleKeys.titles_my_orders.tr(), isButton: true),
            ),
          ),
        ],
      ),
    );
  }
}
