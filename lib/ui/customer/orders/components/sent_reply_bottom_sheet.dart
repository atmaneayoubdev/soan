import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';

class SentReplyBottomSheet extends StatelessWidget {
  const SentReplyBottomSheet({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 381.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(19.r),
          topRight: Radius.circular(19.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            height: 30.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextWidget(
                text: LocaleKeys.provider_home_sent_reply.tr(),
                size: 16,
                color: kDarkBleuColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(
            height: 11.h,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              height: 111.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: kLightLightGreyColor,
              ),
              child: TextField(
                controller: TextEditingController(text: message),
                enabled: false,
                maxLength: null,
                maxLines: null,
                style: GoogleFonts.tajawal(
                  color: kGreyColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.normal,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
