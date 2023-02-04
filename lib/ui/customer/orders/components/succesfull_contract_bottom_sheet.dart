import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../translations/locale_keys.g.dart';

class SuccesfullContractBottomSheet extends StatelessWidget {
  const SuccesfullContractBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(19.r),
          topRight: Radius.circular(19.r),
        ),
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/bottom_sheet_backround.png',
            height: 200.h,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Column(
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
                          topRight: Radius.circular(19.r))),
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
                text: LocaleKeys.costumer_home_contract_succesfull.tr(),
                size: 24,
                color: kDarkBleuColor,
                fontWeight: FontWeight.normal,
              ),
              SizedBox(
                height: 30.h,
              ),
              TextWidget(
                text: LocaleKeys.costumer_home_thanks_for_your_trust.tr(),
                size: 24,
                color: kLightDarkBleuColor,
                fontWeight: FontWeight.normal,
              ),
              TextWidget(
                text: LocaleKeys.costumer_home_you_can_track_order_status.tr(),
                size: 24,
                color: kLightDarkBleuColor,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
