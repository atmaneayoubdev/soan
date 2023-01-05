import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SentInvoiceBottomSheet extends StatelessWidget {
  const SentInvoiceBottomSheet({super.key});

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
            text: LocaleKeys.provider_orders_invoice_was_created.tr(),
            size: 24,
            color: kDarkBleuColor,
            fontWeight: FontWeight.normal,
          ),
          SizedBox(
            height: 20.h,
          ),
          TextWidget(
            text: LocaleKeys.provider_orders_sent_to_client_successfully.tr(),
            size: 24,
            color: kDarkBleuColor,
            fontWeight: FontWeight.normal,
          ),
        ],
      ),
    );
  }
}
