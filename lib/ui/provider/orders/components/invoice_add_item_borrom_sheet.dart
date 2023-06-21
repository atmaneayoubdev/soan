import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../translations/locale_keys.g.dart';

class InvoiceAddItemBottomSheet extends StatelessWidget {
  const InvoiceAddItemBottomSheet({
    super.key,
    required this.nameController,
    required this.valueController,
  });

  final TextEditingController nameController;
  final TextEditingController valueController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 180.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(19.r),
            topRight: Radius.circular(19.r),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 55.h,
                  decoration: BoxDecoration(
                      color: kLightLightGreyColor,
                      borderRadius: BorderRadius.circular(6.r)),
                  width: 286.w,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.tajawal(
                          fontSize: 16.r,
                          color: kLightDarkBleuColor,
                          fontWeight: FontWeight.normal,
                        ),
                        hintText: LocaleKeys.provider_orders_description.tr(),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 55.h,
                  decoration: BoxDecoration(
                      color: kLightLightGreyColor,
                      borderRadius: BorderRadius.circular(6.r)),
                  width: 101.w,
                  child: Align(
                    alignment: Alignment.center,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: valueController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.tajawal(
                          fontSize: 16.r,
                          color: kLightDarkBleuColor,
                          fontWeight: FontWeight.normal,
                        ),
                        hintText:
                            "${LocaleKeys.provider_orders_price.tr()} (${LocaleKeys.common_sar.tr()}) ",
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    height: 55.h,
                    width: 175.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10.r,
                      ),
                      color: kBlueColor,
                    ),
                    child: Center(
                      child: TextWidget(
                        text: LocaleKeys.auth_confirm.tr(),
                        size: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    height: 55.h,
                    width: 175.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10.r,
                      ),
                      color: kLightLightSkyBlueColor,
                    ),
                    child: Center(
                      child: TextWidget(
                        text: LocaleKeys.common_cancel.tr(),
                        size: 14,
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
      ),
    );
  }
}
